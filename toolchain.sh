google docs get --title='Virtuelle Flipper bauen' --dest=vpin --format=docx
pandoc -s -S -t docbook vpin.docx -o vpin.db
xmlstarlet ed -L -d "//sect1[@id='allgemeine-hinweise-für-alle-autoren']" vpin.db
xmlstarlet ed -L -d "//sect1[@id='inhaltsverzeichnis']" vpin.db
xmlto xhtml -m config.xsl vpin.db -o html/
unzip -d tmp vpin.docx
mv tmp/word/media html/
