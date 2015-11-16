jekyll-slack
============

This is Jekyll site is as attempt to create a plug-and-play static Slack archive
website. By dumping the unzipped JSON from your slack team into the `_data`
directory, the generators and layouts on this page will create a static page for
each channel with the full exported history.

## Preprocessing the output

N.B. Slack escapes `/`'s in a way that causes Jekyll to croak when reading the
JSON output. Therefore, you must preprocess every JSON file in the export once
to remove the unnecessary escapes:

```sh
find -f '_data/*.json' . -exec sed -i -e 's/\\\//\//g' {} \;
```
