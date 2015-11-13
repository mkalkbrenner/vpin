# Clean up last run.
rm html/*.html
rm -rf html/media
rm -rf tmp

# Fetch the current document form google as docx. Pandoc produces a better result from docx compared to odf.
#google docs get --title='Virtuelle Flipper bauen' --dest=vpin --format=docx

# Convert the docx to docbook.
pandoc -s -S -t docbook vpin.docx -o vpin.db

# Remove the non content sections from the document.
xmlstarlet ed -L -d "//sect1[@id='allgemeine-hinweise-für-alle-autoren']" vpin.db
xmlstarlet ed -L -d "//sect1[@id='inhaltsverzeichnis']" vpin.db

# Avoid umlauts in URLs
for i in $(seq 1 5)
do
	sed -i .tmp -e 's%\(<sect. id=".*\)ä\(.*">\)%\1ae\2%g' vpin.db
	sed -i .tmp -e 's%\(<sect. id=".*\)ö\(.*">\)%\1oe\2%g' vpin.db
	sed -i .tmp -e 's%\(<sect. id=".*\)ü\(.*">\)%\1ue\2%g' vpin.db
	sed -i .tmp -e 's%\(<sect. id=".*\)ß\(.*">\)%\1ss\2%g' vpin.db
done

#xmlstarlet ed -L -i "/article" --type attr -n "lang" -v "de" vpin.db

# Remove the copyright section because the copyright will be added to the footer of each page by vpin.xsl
xmlstarlet ed -L -d "//sect2[@id='copyright']" vpin.db

# Convert some style elements we use at google docs into real docbook elements. 
xmlstarlet ed -L -r "//sect1[@id='glossar']" -v "glossary" vpin.db
xmlstarlet ed -L -r "//glossary/informaltable" -v "glossentry" vpin.db
xmlstarlet ed -L -r "//glossary/glossentry//thead//entry" -v "glossterm" vpin.db
xmlstarlet ed -L -r "//glossary/glossentry//tbody//entry[1]" -v "glossdef" vpin.db
#all remaining rows become acronyms
xmlstarlet ed -L -r "//glossary/glossentry//tbody//entry" -v "acronym" vpin.db

xmlstarlet ed -L -r "//listitem/blockquote" -v "tmp_blockquote" vpin.db
xmlstarlet ed -L -r "//blockquote" -v "warning" vpin.db
xmlstarlet ed -L -r "//tmp_blockquote" -v "blockquote" vpin.db

xsltproc -o vpin.db.tmp restructure.xsl vpin.db
mv vpin.db.tmp vpin.db

sed -i .tmp -e s#media/#media/small_#g vpin.db
sed -i .tmp -e s#http://files/#files/#g vpin.db

sed -i .tmp -e "s#\[CODE\]#<computeroutput>#g" vpin.db
sed -i .tmp -e "s#\[/CODE\]#</computeroutput>#g" vpin.db

# Create a set of html pages from the docbook format.
xmlto --skip-validation xhtml -m vpin.xsl vpin.db -o html/

sed -i .tmp -e 's%<img src="media/small_\(image.*\)" />%<a href="#" data-featherlight="media/\1">&</a>%g' html/*.html
for html in `ls html/*.html`
do
	sed -i .tmp -n '1h; 1!H; ${ g; s%\(<th align="left">\)\n[[:space:]]*\(<span class="inlinemediaobject">\)%\1\2%g;p;}' $html
done
sed -i .tmp -e 's%\(<table \)border="1"\(>.*data-featherlight\)%\1border="0" width="402" style="background-color:lightgrey"\2%' html/*.html

rm html/*.tmp

# Copy the images form the original docx to the html folder.
unzip -d tmp vpin.docx
mv tmp/word/media html/
cd html/media
for image in `ls`
do
	convert $image -resize 400x800 small_$image
	composite -gravity SouthEast ../../zoom_in.png small_$image small_$image
done
