# Copyright (C) 2006-2014 OpenWrt.org
# Copyright (C) 2006 Fokus Fraunhofer <carsten.tittel@fokus.fraunhofer.de>
# Copyright (C) 2010 Vertical Communications

default_prerm() {
	local root="/opt"
	[ -z "$pkgname" ] && local pkgname="$(basename ${1%.*})"
	local ret=0
	local filelist="${root}/lib/opkg/info/${pkgname}.list"
	[ -f "$root/lib/apk/packages/${pkgname}.list" ] && filelist="$root/lib/apk/packages/${pkgname}.list"

	if [ -e "${root}/lib/apk/packages/${pkgname}.list" ]; then
		filelist="${root}/lib/apk/packages/${pkgname}.list"
		update_alternatives remove "${pkgname}"
	fi

	if [ -f "$root/lib/opkg/info/${pkgname}.prerm-pkg" ]; then
		( . "$root/lib/opkg/info/${pkgname}.prerm-pkg" )
		ret=0
	fi

	local shell="$(command -v bash)"
	for i in $(grep -s "^/opt/etc/init.d/S" "$filelist"); do
		if [ -n "$root" ]; then
			${shell:-/bin/sh} "$i" stop
		else
			"$i" stop
		fi
	done

	/opt/sbin/ldconfig > /dev/null 2>&1

	return $ret
}

update_alternatives() {
	local root="/opt"
	local action="$1"
	local pkgname="$2"

	if [ -f "$root/lib/apk/packages/${pkgname}.alternatives" ]; then
		for pkg_alt in $(cat $root/lib/apk/packages/${pkgname}.alternatives); do
			local best_prio=0;
			local best_src="/opt/bin/busybox";
			pkg_prio=${pkg_alt%%:*};
			pkg_target=${pkg_alt#*:};
			pkg_target=${pkg_target%:*};
			pkg_src=${pkg_alt##*:};

			if [ -e "$target" ]; then
				for alts in $root/lib/apk/packages/*.alternatives; do
					for alt in $(cat $alts); do
						prio=${alt%%:*};
						target=${alt#*:};
						target=${target%:*};
						src=${alt##*:};

						if [ "$target" = "$pkg_target" ] &&
						   [ "$src" != "$pkg_src" ] &&
						   [ "$best_prio" -lt "$prio" ]; then
							best_prio=$prio;
							best_src=$src;
						fi
					done
				done
			fi
			case "$action" in
				install)
					if [ "$best_prio" -lt "$pkg_prio" ]; then
						ln -sf "$pkg_src" "$pkg_target"
						echo "add alternative: $pkg_target -> $pkg_src"
					fi
				;;
				remove)
					if [ "$best_prio" -lt "$pkg_prio" ]; then
						ln -sf "$best_src" "$pkg_target"
						echo "restore alternative: $pkg_target -> $best_src"
					fi
				;;
			esac
		done
	fi
}

user_exists() {
	grep -qs "^${1}:" /opt/etc/passwd
}

user_add() {
	local name="${1}"
	local uid="${2}"
	local gid="${3}"
	local desc="${4:-$1}"
	local home="${5:-/opt/var/run/$1}"
	local shell="${6:-/opt/bin/false}"
	local rc
	[ -z "$uid" ] && {
		uids=$(cut -d: -f3 /opt/etc/passwd)
		uid=32768
		while echo "$uids" | grep -q "^$uid$"; do
			uid=$((uid + 1))
		done
	}
	[ -z "$gid" ] && gid=$uid
	[ -f "/opt/etc/passwd" ] || return 1
	lock /opt/var/lock/passwd
	echo "${name}:x:${uid}:${gid}:${desc}:${home}:${shell}" >> /opt/etc/passwd
	echo "${name}:x:0:0:99999:7:::" >> /opt/etc/shadow
	lock -u /opt/var/lock/passwd
}

group_exists() {
	grep -qs "^${1}:" /opt/etc/group
}

group_add() {
	local name="$1"
	local gid="$2"
	local rc
	[ -f "/opt/etc/group" ] || return 1
	lock /opt/var/lock/group
	echo "${name}:x:${gid}:" >> /opt/etc/group
	lock -u /opt/var/lock/group
}

group_add_next() {
	local gid gids
	gid=$(grep -s "^${1}:" /opt/etc/group | cut -d: -f3)
	if [ -n "$gid" ]; then
		echo $gid
		return
	fi
	gids=$(cut -d: -f3 /opt/etc/group)
	gid=32768
	while echo "$gids" | grep -q "^$gid$"; do
		gid=$((gid + 1))
	done
	group_add $1 $gid
	echo $gid
}

group_add_user() {
	local grp delim=","
	grp=$(grep -s "^${1}:" /opt/etc/group)
	echo "$grp" | cut -d: -f4 | grep -q $2 && return
	echo "$grp" | grep -q ":$" && delim=""
	lock /opt/var/lock/passwd
	sed -i "s/$grp/$grp$delim$2/g" /opt/etc/group
	lock -u /opt/var/lock/passwd
}

add_group_and_user() {
	[ -z "$pkgname" ] && local pkgname="$(basename ${1%.*})"
	local rusers="$(sed -ne 's/^Require-User: *//p' $root/lib/opkg/info/${pkgname}.control 2>/dev/null)"
	if [ -f "$root/lib/apk/packages/${pkgname}.rusers" ]; then
		local rusers="$(cat $root/lib/apk/packages/${pkgname}.rusers)"
	fi

	if [ -n "$rusers" ]; then
		local tuple oIFS="$IFS"
		for tuple in $rusers; do
			local uid gid uname gname addngroups addngroup addngname addngid

			IFS=":"
			set -- $tuple; uname="$1"; gname="$2"; addngroups="$3"
			IFS="="
			set -- $uname; uname="$1"; uid="$2"
			set -- $gname; gname="$1"; gid="$2"
			IFS="$oIFS"

			if [ -n "$gname" ] && [ -n "$gid" ]; then
				group_exists "$gname" || group_add "$gname" "$gid"
			elif [ -n "$gname" ]; then
				gid="$(group_add_next "$gname")"
			fi

			if [ -n "$uname" ]; then
				user_exists "$uname" || user_add "$uname" "$uid" "$gid"
			fi

			if [ -n "$uname" ] && [ -n "$gname" ]; then
				group_add_user "$gname" "$uname"
			fi

			if [ -n "$uname" ] &&  [ -n "$addngroups" ]; then
				oIFS="$IFS"
				IFS=","
				for addngroup in $addngroups ; do
					IFS="="
					set -- $addngroup; addngname="$1"; addngid="$2"
					if [ -n "$addngid" ]; then
						group_exists "$addngname" || group_add "$addngname" "$addngid"
					else
						group_add_next "$addngname"
					fi

					group_add_user "$addngname" "$uname"
				done
				IFS="$oIFS"
			fi

			unset uid gid uname gname addngroups addngroup addngname addngid
		done
	fi
}

default_postinst() {
	local root="/opt"
	[ -z "$pkgname" ] && local pkgname="$(basename ${1%.*})"
	local filelist="${root}/lib/opkg/info/${pkgname}.list"
	[ -f "$root/lib/apk/packages/${pkgname}.list" ] && filelist="$root/lib/apk/packages/${pkgname}.list"
	local ret=0

	if [ -e "${root}/lib/opkg/info/${pkgname}.list" ]; then
		filelist="${root}/lib/opkg/info/${pkgname}.list"
		add_group_and_user "${pkgname}"
	fi

	if [ -e "${root}/lib/apk/packages/${pkgname}.list" ]; then
		filelist="${root}/lib/apk/packages/${pkgname}.list"
		update_alternatives install "${pkgname}"
	fi

	if [ -f "$root/lib/opkg/info/${pkgname}.postinst-pkg" ]; then
		( . "$root/lib/opkg/info/${pkgname}.postinst-pkg" )
		ret=0
	fi

	local shell="$(command -v bash)"
	for i in $(grep -s "^/opt/etc/init.d/S" "$filelist"); do
		if [ -n "$root" ]; then
			${shell:-/bin/sh} "$i" start
		else
			"$i" start
		fi
	done

	/opt/sbin/ldconfig > /dev/null 2>&1

	return $ret
}
