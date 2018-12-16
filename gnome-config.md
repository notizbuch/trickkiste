#### new laucher

```
mkdir -p ~/myprofile2/chrome
cat << EOF > ~/.local/share/applications/myprofile2.desktop 
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=/usr/share/icons/myicon.png
Exec=/usr/bin/google-chrome-stable --profile-directory=~/myprofile2/chrome
Name[en_US]=MyProfile2
Name=MyProfile2
Icon=/usr/share/icons/myicon.png
EOF
```
