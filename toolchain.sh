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
xmlstarlet ed -L -r "//sect1[@id='glossar']" -v "glossary" vpin.db
xmlstarlet ed -L -r "//glossary/informaltable" -v "glossentry" vpin.db
xmlstarlet ed -L -r "//glossary/glossentry//thead//entry" -v "glossterm" vpin.db
xmlstarlet ed -L -r "//glossary/glossentry//tbody//entry[1]" -v "glossdef" vpin.db
#all remaining rows become acronyms
xmlstarlet ed -L -r "//glossary/glossentry//tbody//entry" -v "acronym" vpin.db

NUM_ENTRIES=`xmlstarlet sel -t -v "count(//glossterm)" vpin.db`
for i in $(seq $NUM_ENTRIES 1)
do
	xmlstarlet ed -L -m "//glossentry[$i]//glossterm" "//glossentry[$i]" vpin.db
	xmlstarlet ed -L -m "//glossentry[$i]//acronym" "//glossentry[$i]" vpin.db
	xmlstarlet ed -L -m "//glossentry[$i]//glossdef" "//glossentry[$i]" vpin.db
done

xmlstarlet ed -L -d "//glossentry/tgroup" vpin.db
xmlstarlet ed -L -d "//glossentry/acronym[not(normalize-space())]" vpin.db
xmlstarlet ed -L -s "//glossentry/glossdef[not(normalize-space())]" -t elem -n 'para' -v 'Beschreibung folgt später.' vpin.db

NUM_ENTRIES=`xmlstarlet sel -t -v "count(//glossdef[not(para)])" vpin.db`
for i in $(seq $NUM_ENTRIES 1)
do
	TEXT=`xmlstarlet sel -t -v "//glossdef[not(para)][$i]" vpin.db`
	xmlstarlet ed -L -s "//glossdef[not(para)][$i]" -t elem -n 'para' -v "$TEXT" vpin.db
done

xmlstarlet ed -L -d "//glossdef/text()" vpin.db

xmlstarlet ed -L -r "//listitem/blockquote" -v "tmp_blockquote" vpin.db
xmlstarlet ed -L -r "//blockquote" -v "warning" vpin.db
xmlstarlet ed -L -r "//tmp_blockquote" -v "blockquote" vpin.db

sed -i .tmp -e s#media/#media/small_#g vpin.db

# Create a set of html pages from the docbook format.
xmlto xhtml -m vpin.xsl vpin.db -o html/

sed -i .bak -e 's%<img src="media/small_\(image.*\)" />%<a href="#" data-featherlight="media/\1">&</a>%g' html/*.html
for html in `ls html/*.html`
do
	sed -i .bak -n '1h; 1!H; ${ g; s%\(<th align="left">\)\n[[:space:]]*\(<span class="inlinemediaobject">\)%\1\2%g;p;}' $html
done
sed -i .bak -e 's%\(<table \)border="1"\(>.*data-featherlight\)%\1border="0" width="402" style="background-color:lightgrey"\2%' html/*.html

rm html/*.bak

# Copy the images form the original docx to the html folder.
unzip -d tmp vpin.docx
mv tmp/word/media html/
cd html/media
for image in `ls`
do
	convert $image -resize 400x400 small_$image
	composite -gravity SouthEast ../../zoom_in.png small_$image small_$image
done
