# GankScan
Wow Classic addon - GankScan

Addon used for scanning after people that you wanna gank if they ever appear within range.

# Add Ganking Target
/gs add {NAME}
/gankscan add {NAME}

# Remove Ganking Target
/gs remove {NAME}
/gankscan remove {NAME}

# Behaviour
Every fifth second GankScan will scan for targets with names in the GankTargets list.

When target is found, it will still exist in the list. But will be set to false, which means that GankScan will not scan for this target anymore.
If you want to start scanning for a gank target again, add them to the list using commands above.
