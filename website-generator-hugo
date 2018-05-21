#### getting started

'''
#!/bin/bash

hugo new site $1

cd $1

hugo new theme $1

echo theme = \"$1\" >> config.toml

hugo new pages/page1.md

echo this is page1 >> content/pages/page1.md

echo \{\{ \.Content \}\} >> themes/$1/layouts/_default/single.html

hugo
'''
