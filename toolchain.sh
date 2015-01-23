google docs get --title='Virtuelle Flipper bauen' --dest=vpin --format=docx
pandoc -s -S -t docbook vpin.docx -o vpin.db
xmlto xhtml -m config.xsl vpin.db -o html/
