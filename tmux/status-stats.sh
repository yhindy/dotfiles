#!/bin/sh
# CPU / memory / disk for the tmux status bar. Works on Linux and macOS, no
# plugin manager. Called once per status-interval, so it must be fast and must
# never block: CPU is sampled by diffing against the previous call's counters
# (kept in a state file) instead of sleeping between two reads.

state="${TMPDIR:-/tmp}/.tmux-cpu-$(id -u)"

cpu_linux() {
  set -- $(awk '/^cpu /{print $2,$3,$4,$5,$6,$7,$8}' /proc/stat)
  total=$(( $1 + $2 + $3 + $4 + $5 + $6 + $7 ))
  idle=$(( $4 + $5 ))
  if [ -r "$state" ]; then
    read ptotal pidle < "$state"
  else
    ptotal=0; pidle=0
  fi
  echo "$total $idle" > "$state"
  dt=$(( total - ptotal ))
  di=$(( idle - pidle ))
  if [ "$ptotal" -eq 0 ] || [ "$dt" -le 0 ]; then
    echo "--"
  else
    echo $(( (100 * (dt - di) + dt / 2) / dt ))
  fi
}

cpu_macos() {
  ncpu=$(sysctl -n hw.ncpu 2>/dev/null || echo 1)
  ps -A -o %cpu= 2>/dev/null | awk -v n="$ncpu" '
    {s += $1} END {v = s / n; if (v > 100) v = 100; printf "%d", v + 0.5}'
}

mem_linux() {
  awk '/^MemTotal:/{t=$2} /^MemAvailable:/{a=$2}
       END {printf "%.1f/%.0fG", (t-a)/1048576, t/1048576}' /proc/meminfo
}

mem_macos() {
  total=$(sysctl -n hw.memsize)
  vm_stat | awk -v total="$total" '
    /page size of/ {ps = $8}
    /Pages active/ {act = $3}
    /Pages wired down/ {wir = $4}
    /Pages occupied by compressor/ {cmp = $5}
    END {
      gsub(/\./, "", act); gsub(/\./, "", wir); gsub(/\./, "", cmp)
      used = (act + wir + cmp) * ps
      printf "%.1f/%.0fG", used / 1073741824, total / 1073741824
    }'
}

case "$(uname -s)" in
  Darwin) cpu=$(cpu_macos); mem=$(mem_macos) ;;
  *)      cpu=$(cpu_linux); mem=$(mem_linux) ;;
esac

disk=$(df -P / 2>/dev/null | awk 'NR==2 {gsub(/%/, "", $5); print $5}')

printf 'CPU %s%% │ MEM %s │ DISK %s%%' "$cpu" "$mem" "${disk:---}"
