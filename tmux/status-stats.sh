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
       END {printf "%4.1f/%.0fG", (t-a)/1048576, t/1048576}' /proc/meminfo
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
      printf "%4.1f/%.0fG", used / 1073741824, total / 1073741824
    }'
}

case "$(uname -s)" in
  Darwin) cpu=$(cpu_macos); mem=$(mem_macos) ;;
  *)      cpu=$(cpu_linux); mem=$(mem_linux) ;;
esac

disk=$(df -P / 2>/dev/null | awk 'NR==2 {gsub(/%/, "", $5); print $5}')

# Icons instead of CPU/MEM/DISK labels — buys back ~12 columns on a split pane.
# All three have inherent emoji presentation, so tmux measures them as 2 columns;
# don't swap in an icon that needs a U+FE0F variation selector (see .tmux.conf).
#
# Every field is padded to a fixed width. status-right is right-aligned, so a
# value that grows a digit (9% -> 13%) would otherwise shove every icon to its
# left one column sideways on each refresh.
printf '💻 %3s%% │ 🧠 %s │ 💾 %3s%%' "$cpu" "$mem" "${disk:---}"
