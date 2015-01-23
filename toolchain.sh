# Clean up last run.
rm html/*.html
rm -rf html/media
rm -rf tmp

# Fetch the current document form google as docx. Pandoc produces a better result from docx compared to odf.
google docs get --title='Virtuelle Flipper bauen' --dest=vpin --format=docx

# Convert the docx to docbook.
pandoc -s -S -t docbook vpin.docx -o vpin.db

# Remove the non content sections from the document.
xmlstarlet ed -L -d "//sect1[@id='allgemeine-hinweise-für-alle-autoren']" vpin.db
xmlstarlet ed -L -d "//sect1[@id='inhaltsverzeichnis']" vpin.db

# Remove the copyright section because the copyright will be added to the footer of each page by vpin.xsl
xmlstarlet ed -L -d "//sect2[@id='copyright']" vpin.db

# Convert some style elements we use at google docs into real docbook elements. 
xmlstarlet ed -L -r '//blockquote' -v 'warning' vpin.db
xmlstarlet ed -L -r '//para[emphasis[not(@*)]]' -v 'blockquote' vpin.db
xmlstarlet ed -L -r '//blockquote/emphasis' -v 'para' vpin.db

# Create a set of html pages from the docbook format.
xmlto xhtml -m vpin.xsl vpin.db -o html/

# Copy the images form the original docx to the html folder.
unzip -d tmp vpin.docx
mv tmp/word/media html/

