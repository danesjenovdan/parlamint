# extract the lemmatizer model
echo '[INFO] Extracting the lemmatizer model ...'
unzip -o parladata/tagger/model.zip -d parladata/tagger/
echo '[SUCCESS!] Lemmatizer model extracted!'
echo ''

# run and build all the things
echo '[INFO] Running docker-compose up ...'
sudo docker-compose up --build -d parladata db parlasite parlanode solr
echo '[SUCCESS!] Containers running!'
echo ''

echo '[INFO] Migrating database ...'
sudo docker-compose exec parladata python manage.py migrate
echo '[SUCCESS!] Database migrated!'
echo ''

echo '[INFO] Creating super user. This is interactive, please answer the questions.'
sudo docker-compose exec parladata python manage.py createsuperuser
echo '[SUCCESS!] Superuser created!'
echo ''

echo '[INFO] Downloading slovenian dataset ...'
cd parlamint-parser/data && curl --remote-name-all https://www.clarin.si/repository/xmlui/bitstream/handle/11356/1432{/ParlaMint-$1.tgz}
echo '[SUCCESS!] Successfully downloaded data'
echo ''

echo '[INFO] Unzipping data ...'
tar -zxvf ParlaMint-$1.tgz
echo '[SUCCESS!] Done unzipping!'
echo ''

echo '[INFO] Starting to parse the stuff'
sudo docker-compose build parser
sudo docker-compose run parser python parser.py $1
echo '[SUCCESS!] Parsed everything.'
echo ''

echo '[INFO] Lemmatizing speeches.'
sudo docker-compose exec parladata python manage.py lemmatize_speeches
echo '[SUCCESS!] Speeches lemmatized.'
echo ''

echo '[INFO] Creating core and copying config ...'
sudo docker-compose exec solr /opt/docker-solr/scripts/precreate-core parlasearch
sudo docker-compose exec solr cp -f /parlasearch-conf/schema.xml /opt/solr/server/solr/mycores/parlasearch/conf/
sudo docker-compose exec solr cp -f /parlasearch-conf/solrconfig.xml /opt/solr/server/solr/mycores/parlasearch/conf/
sudo docker-compose restart solr
echo '[SUCCESS!] Core created and config copied.'
echo ''

echo '[INFO] Copying speeches to SOLR.'
sudo docker-compose exec parladata python manage.py upload_speeches_to_solr
echo '[SUCCESS!] Speeches uploaded to SOLR.'
echo ''

echo '[INFO] Calculating scores.'
sudo docker-compose exec parladata python manage.py seed_scores 1
echo '[SUCCESS!] Scores calculated.'
echo ''

echo '[SUCCESS!] We are all done. You can visit Parlameter at http://localhost:3066/'
echo '           To stop it, run `sudo docker-compose stop`'
echo '           And to get it up again run `sudo docker-compose up`'
