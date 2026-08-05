#!/usr/bin/env python3
"""Assemble the single-file JollyJaunter app: inlines Leaflet + Supabase libs into app.template.html."""
tpl = open("app.template.html").read()
for marker, path in [("/*__LEAFLET_CSS__*/", "lib/leaflet.min.css"),
                     ("/*__LEAFLET_JS__*/", "lib/leaflet.min.js"),
                     ("/*__SUPABASE_JS__*/", "lib/supabase.min.js")]:
    assert marker in tpl, f"missing marker {marker}"
    tpl = tpl.replace(marker, open(path).read())
open("jollyjaunter.html", "w").write(tpl)
print(f"built jollyjaunter.html ({len(tpl):,} bytes)")
