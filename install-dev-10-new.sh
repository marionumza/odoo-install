#!/bin/bash

#--------------------------------------------------
# Update Server
#--------------------------------------------------
echo -e "\n---- Update Server ----"
apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y
apt-get install -y dirmngr --install-recommends
apt-get install software-properties-common sudo -y
apt-get install default-jre -y
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get install default-jdk -y
apt-get update
apt-get install oracle-java8-installer -y
add-apt-repository -y ppa:mystic-mirage/pycharm
apt-get update


echo "Installazione Database Postgresql"
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
apt-get upgrade -y
apt-get install -y postgresql-9.6 postgresql-server-dev-9.6 pgadmin3 pgadmin4

echo -e "\n---- Install tool packages ----"
apt-get install wget subversion git bzr bzrtools python-pip python3-pip gdebi-core -y

apt-get install -y libsasl2-dev python-dev libldap2-dev libssl-dev python-dev python3-dev libxml2-dev libxslt1-dev zlib1g-dev python-pip python3-pip python-wheel python3-wheel python-setuptools python3-setuptools python3-babel python3-bs4 python3-cffi-backend python3-cryptography python3-dateutil python3-docutils python3-feedparser python3-funcsigs python3-gevent python3-greenlet python3-html2text python3-html5lib python3-jinja2 python3-lxml python3-mako python3-markupsafe python3-mock python3-ofxparse python3-openssl python3-passlib python3-pbr python3-pil python3-psutil python3-psycopg2 python3-pydot python3-pygments python3-pyparsing python3-pypdf2 python3-renderpm python3-reportlab python3-reportlab-accel python3-roman python3-serial python3-stdnum python3-suds python3-tz python3-usb python3-vatnumber python3-werkzeug python3-xlsxwriter python3-yaml python-babel python-bs4 python-cffi-backend python-cryptography python-dateutil python-docutils python-feedparser python-funcsigs python-gevent python-greenlet python-html2text python-html5lib python-jinja2 python-lxml python-mako python-markupsafe python-mock python-ofxparse python-openssl python-passlib python-pbr python-pil python-psutil python-psycopg2 python-pydot python-pygments python-pyparsing python-pypdf2 python-renderpm python-reportlab python-reportlab-accel python-roman python-serial python-stdnum python-suds python-tz python-usb python-vatnumber python-werkzeug python-xlsxwriter python-yaml python-pychart
/usr/local/bin/pip install --upgrade -r https://raw.githubusercontent.com/odoo/odoo/10.0/requirements.txt

wget https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.xenial_amd64.deb
gdebi --n wkhtmltox_0.12.5-1.xenial_amd64.deb

echo -e "\n---- Install python libraries ----"
# This is for compatibility with Ubuntu 16.04. Will work on 14.04, 15.04 and 16.04
apt-get install python-suds python3-suds -y

echo -e "\n--- Install other required packages"
apt-get install node-clean-css node-less python-gevent -y

apt-get install python-m2crypto -y

#echo -e "\n--- Create symlink for node"
#ln -s /usr/bin/nodejs /usr/bin/node

/usr/local/bin/pip install num2words ofxparse
apt-get install nodejs npm node-less -y
#npm install -g less
#npm install -g less-plugin-clean-css	

pip install --upgrade pip

apt-get install -y default-jre ure libgoogle-gson-java libreoffice-java-common libreoffice-writer
apt-get install -y msttcorefonts

echo "Installazione pacchetti py3o"
/usr/local/bin/pip install py3o.template
/usr/local/bin/pip install py3o.formats
/usr/local/bin/pip install py3o.fusion
/usr/local/bin/pip install service-identity
/usr/local/bin/pip install py3o.renderserver



echo '#!/bin/sh' > /home/odoo/bin/py3o.renderserver
echo '' >> /home/odoo/bin/py3o.renderserver
echo '/usr/local/bin/start-py3o-renderserver --java=/usr/lib/jvm/default-java/jre/lib/amd64/server/libjvm.so --ure=/usr/share --office=/usr/lib/libreoffice --driver=juno --sofficeport=8997 &'  >> /home/odoo/bin/py3o.renderserver
chmod +x /home/odoo/bin/py3o.renderserver
chown odoo:odoo /home/odoo/bin/py3o.renderserver


echo '#!/bin/sh' > /home/odoo/bin/py3o.fusion
echo '' >> /home/odoo/bin/py3o.fusion
echo '/usr/local/bin/start-py3o-fusion -s localhost'  >> /home/odoo/bin/py3o.fusion
chmod +x /home/odoo/bin/py3o.fusion
chown odoo:odoo /home/odoo/bin/py3o.fusion



	
	
echo "Installazione Odoo 10.0"
sudo -u postgres createuser -s odoo
sudo -u postgres psql -c "ALTER USER odoo WITH PASSWORD 'odoo';"
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'odoo';"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/OCB.git /home/odoo/odoodev10/server"
su - odoo -c "mkdir -p /home/odoo/odoodev10/addons"
su - odoo -c "git clone -b 10.0 https://github.com/OCA/reporting-engine /home/odoo/odoodev10/source/2-OCA/reporting-engine"
/usr/local/bin/pip install --upgrade -r /home/odoo/odoodev10/source/2-OCA/reporting-engine/requirements.txt

chown -R odoo:odoo /home/odoo/odoodev10/server
chown -R odoo:odoo /home/odoo/odoodev10
/usr/local/bin/pip install geojson

echo "Installazione pyxb"
/usr/local/bin/pip install pyxb==1.2.5

echo "Installazione codicefiscale"
/usr/local/bin/pip install codicefiscale

echo "Installazione simplejson"
/usr/local/bin/pip install simplejson

echo "Installazione unidecode"
/usr/local/bin/pip install unidecode

echo "Installazione phonenumbers"
/usr/local/bin/pip install phonenumbers

echo "Installazione numpy"
/usr/local/bin/pip install numpy

echo "Installazione cachetools"
/usr/local/bin/pip install cachetools

/usr/local/bin/pip install pyPdf


su - odoo -c 'for d in $( ls odoodev10/source); do  find $(pwd)/odoodev10/source/$d -mindepth 2 -maxdepth 2 -type d -exec sh -c "ln -sfn \"{}\" $(pwd)/odoodev10/addons" \;; done'

su - odoo -c "/home/odoo/odoodev10/server/odoo-bin --stop-after-init -s -c /home/odoo/odoodev10/odoo_serverrc --db_host=localhost --db_user=odoo --db_password=odoo --addons-path=/home/odoo/odoodev10/server/odoo/addons,/home/odoo/odoodev10/server/addons,/home/odoo/odoodev10/addons"

su - odoo -c "mkdir bin"
su - odoo -c "cat <<EOF > ~/bin/o10
#!/bin/sh
/home/odoo/odoodev10/server/odoo-bin -c /home/odoo/odoodev10/odoo_serverrc
EOF"
su - odoo -c "chmod 755 ~/bin/o10"

su - odoo -c "cat <<EOF > ~/bin/o10up
#!/bin/sh
/home/odoo/odoodev10/server/odoo-bin -c /home/odoo/odoodev10/odoo_serverrc -d test --stop-after-init -u all
EOF"
su - odoo -c "chmod 755 ~/bin/o10up"


su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/server-tools  /home/odoo/odoodev10/source/2-OCA/server-tools"
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/server-tools/requirements.txt
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/server-ux  /home/odoo/odoodev10/source/2-OCA/server-ux"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/partner-contact  /home/odoo/odoodev10/source/2-OCA/partner-contact"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/l10n-italy  /home/odoo/odoodev10/source/2-OCA/l10n-italy"

su - odoo -c "git clone -b 10.0 --single-branch https://github.com/ingadhoc/miscellaneous  /home/odoo/odoodev10/source/3-ingadhoc/miscellaneous"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/ingadhoc/odoo-argentina  /home/odoo/odoodev10/source/3-ingadhoc/odoo-argentina"
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/odoo-argentina/requirements.txt
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/ingadhoc/argentina-sale  /home/odoo/odoodev10/source/3-ingadhoc/argentina-sale"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/ingadhoc/argentina-reporting  /home/odoo/odoodev10/source/3-ingadhoc/argentina-reporting"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/ingadhoc/account-financial-tools  /home/odoo/odoodev10/source/3-ingadhoc/account-financial-tools"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/ingadhoc/reporting-engine  /home/odoo/odoodev10/source/3-ingadhoc/reporting-engine"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/ingadhoc/account-payment  /home/odoo/odoodev10/source/3-ingadhoc/account-payment"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/ingadhoc/partner  /home/odoo/odoodev10/source/3-ingadhoc/partner"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/ingadhoc/sale  /home/odoo/odoodev10/source/3-ingadhoc/sale"
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/sale/requirements.txt
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/ingadhoc/account-invoicing  /home/odoo/odoodev10/source/3-ingadhoc/account-invoicing"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/ingadhoc/product  /home/odoo/odoodev10/source/3-ingadhoc/product"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/account-payment  /home/odoo/odoodev10/source/2-OCA/account-payment"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/account-financial-reporting  /home/odoo/odoodev10/source/2-OCA/account-financial-reporting"
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/account-financial-reporting/requirements.txt
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/account-financial-tools  /home/odoo/odoodev10/source/2-OCA/account-financial-tools"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/account-closing  /home/odoo/odoodev10/source/2-OCA/account-closing"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/account-analytic  /home/odoo/odoodev10/source/2-OCA/account-analytic"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/account-invoicing  /home/odoo/odoodev10/source/2-OCA/account-invoicing"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/account-invoice-reporting  /home/odoo/odoodev10/source/2-OCA/account-invoice-reporting"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/account-budgeting /home/odoo/odoodev10/source/2-OCA/account-budgeting"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/account-consolidation /home/odoo/odoodev10/source/2-OCA/account-consolidation"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/bank-payment  /home/odoo/odoodev10/source/2-OCA/bank-payment"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/bank-statement-reconcile  /home/odoo/odoodev10/source/2-OCA/bank-statement-reconcile"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/bank-statement-import  /home/odoo/odoodev10/source/2-OCA/bank-statement-import"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/product-attribute  /home/odoo/odoodev10/source/2-OCA/product-attribute"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/product-variant /home/odoo/odoodev10/source/2-OCA/product-variant"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/stock-logistics-warehouse  /home/odoo/odoodev10/source/2-OCA/stock-logistics-warehouse"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/stock-logistics-tracking  /home/odoo/odoodev10/source/2-OCA/stock-logistics-tracking"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/stock-logistics-barcode  /home/odoo/odoodev10/source/2-OCA/stock-logistics-barcode"
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/stock-logistics-barcode/requirements.txt
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/stock-logistics-workflow  /home/odoo/odoodev10/source/2-OCA/stock-logistics-workflow"
su - odoo -c "git clone -b 10.0-mig-stock_picking_package_preparation --single-branch https://github.com/dcorio/stock-logistics-workflow  /home/odoo/odoodev10/source/1-dcorio/10.0-mig-stock_picking_package_preparation"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/stock-logistics-transport  /home/odoo/odoodev10/source/2-OCA/stock-logistics-transport"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/sale-workflow  /home/odoo/odoodev10/source/2-OCA/sale-workflow"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/sale-financial /home/odoo/odoodev10/source/2-OCA/sale-financial"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/sale-reporting /home/odoo/odoodev10/source/2-OCA/sale-reporting"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/web  /home/odoo/odoodev10/source/2-OCA/web"
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/web/requirements.txt
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/website  /home/odoo/odoodev10/source/2-OCA/website"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/event /home/odoo/odoodev10/source/2-OCA/event"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/survey /home/odoo/odoodev10/source/2-OCA/survey"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/social  /home/odoo/odoodev10/source/2-OCA/social"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/e-commerce  /home/odoo/odoodev10/source/2-OCA/e-commerce"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/commission /home/odoo/odoodev10/source/2-OCA/commission"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/margin-analysis  /home/odoo/odoodev10/source/2-OCA/margin-analysis"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/contract  /home/odoo/odoodev10/source/2-OCA/contract"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/rma  /home/odoo/odoodev10/source/2-OCA/rma"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/crm  /home/odoo/odoodev10/source/2-OCA/crm"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/project-service  /home/odoo/odoodev10/source/2-OCA/project-service"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/carrier-delivery  /home/odoo/odoodev10/source/2-OCA/carrier-delivery"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/stock-logistics-reporting /home/odoo/odoodev10/source/2-OCA/stock-logistics-reporting"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/hr-timesheet  /home/odoo/odoodev10/source/2-OCA/hr-timesheet"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/hr  /home/odoo/odoodev10/source/2-OCA/hr"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/management-system  /home/odoo/odoodev10/source/2-OCA/management-system"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/report-print-send  /home/odoo/odoodev10/source/2-OCA/report-print-send"
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/report-print-send/requirements.txt 
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/purchase-reporting  /home/odoo/odoodev10/source/2-OCA/purchase-reporting"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/purchase-workflow  /home/odoo/odoodev10/source/2-OCA/purchase-workflow"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/manufacture-reporting  /home/odoo/odoodev10/source/2-OCA/manufacture-reporting"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/knowledge  /home/odoo/odoodev10/source/2-OCA/knowledge"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/project-reporting  /home/odoo/odoodev10/source/2-OCA/project-reporting"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/project  /home/odoo/odoodev10/source/2-OCA/project"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/it-projects-llc/misc-addons  /home/odoo/odoodev10/source/4-it-projects-llc/misc-addons"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/it-projects-llc/access-addons  /home/odoo/odoodev10/source/4-it-projects-llc/access-addons"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/it-projects-llc/pos-addons  /home/odoo/odoodev10/source/4-it-projects-llc/pos-addons"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/it-projects-llc/website-addons  /home/odoo/odoodev10/source/4-it-projects-llc/website-addons"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/it-projects-llc/mail-addons  /home/odoo/odoodev10/source/4-it-projects-llc/mail-addons"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/vauxoo/addons-vauxoo /home/odoo/odoodev10/source/5-vauxoo/addons-vauxoo"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/onesteinbv/addons-onestein  /home/odoo/odoodev10/source/6-onesteinbv/addons-onestein"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/connector /home/odoo/odoodev10/source/2-OCA/connector"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/queue /home/odoo/odoodev10/source/2-OCA/queue"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/multi-company  /home/odoo/odoodev10/source/2-OCA/multi-company"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/pos  /home/odoo/odoodev10/source/2-OCA/pos"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/fcoach66/odoo-italy-extra  /home/odoo/odoodev10/source/7-fcoach66/odoo-italy-extra"

su - odoo -c "git clone -b 10.0 --single-branch https://github.com/akretion/odoo-usability /home/odoo/odoodev10/source/6-akretion/odoo-usability"



su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/community-data-files  /home/odoo/odoodev10/source/2-OCA/community-data-files"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/geospatial  /home/odoo/odoodev10/source/2-OCA/geospatial"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/vertical-isp  /home/odoo/odoodev10/source/2-OCA/vertical-isp"

su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/hr-timesheet /home/odoo/odoodev10/source/2-OCA/hr-timesheet"

su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/server-auth /home/odoo/odoodev10/source/2-OCA/server-auth"

su - odoo -c "git clone -b 10.0-mig-invoice_comment_template --single-branch https://github.com/QubiQ/account-invoice-reporting /home/odoo/odoodev10/source/1-QubiQ/account-invoice-reporting"

su - odoo -c "git clone -b 10.0 --single-branch https://github.com/QubiQ/qu-server-tools /home/odoo/odoodev10/source/1-QubiQ/qu-server-tools"

su - odoo -c "git clone -b feature/10.0-mig-account_fiscal_position_vat_check --single-branch https://github.com/rven/account-financial-tools /home/odoo/odoodev10/source/1-rven/10.0-mig-account_fiscal_position_vat_check-account-financial-tools"
su - odoo -c "git clone -b 10.0-porting-l10n_it_vat_registries --single-branch https://github.com/eLBati/l10n-italy/ /home/odoo/odoodev10/source/1-eLBati/10.0-porting-l10n_it_vat_registries-l10n-italy"

su - odoo -c "git clone -b 10.0-mig-account_analytic_distribution --single-branch https://github.com/Tecnativa/account-analytic/ /home/odoo/odoodev10/source/1-Tecnativa/10.0-mig-account_analytic_distribution-account-analytic"

su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/intrastat /home/odoo/odoodev10/source/2-OCA/intrastat"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/edi /home/odoo/odoodev10/source/2-OCA/edi"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/account-reconcile /home/odoo/odoodev10/source/2-OCA/account-reconcile"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/operating-unit /home/odoo/odoodev10/source/2-OCA/operating-unit"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/currency /home/odoo/odoodev10/source/2-OCA/currency"
su - odoo -c "git clone -b 10.0 --single-branch https://github.com/OCA/website-themes /home/odoo/odoodev10/source/2-OCA/website-themes"

su - odoo -c "git clone -b 10.0 --single-branch https://github.com/Yenthe666/auto_backup /home/odoo/odoodev10/source/1-Yenthe666/auto_backup"
pip install -r /home/odoo/odoodev10/source/1-Yenthe666/auto_backup/requirements.txt

su - odoo -c "git clone -b 10.0-mig-account_asset_management https://github.com/grindtildeath/account-financial-tools /home/odoo/odoodev10/source/1-grindtildeath/10.0-mig-account_asset_management-account-financial-tools"


su - odoo -c "find . -type d -name .git -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;"
su - odoo -c 'for d in $( ls odoodev10/source); do  find $(pwd)/odoodev10/source/$d -mindepth 2 -maxdepth 2 -type d -exec sh -c "ln -sfn \"{}\" $(pwd)/odoodev10/addons" \;; done'


/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/product/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/account-invoicing/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/reporting-engine/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/partner/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/sale/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/stock-logistics-barcode/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/server-tools/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/account-financial-tools/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/web/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/account-financial-reporting/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/reporting-engine/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/report-print-send/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/5-vauxoo/addons-vauxoo/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/4-it-projects-llc/misc-addons/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/4-it-projects-llc/website-addons/requirements.txt

/usr/local/bin/pip install email_validator



/usr/local/bin/pip install -r /home/odoo/odoodev10/server/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/4-it-projects-llc/misc-addons/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/4-it-projects-llc/website-addons/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/4-it-projects-llc/pos-addons/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/1-Yenthe666/auto_backup/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/1-rven/10.0-mig-account_fiscal_position_vat_check-account-financial-tools/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/5-vauxoo/addons-vauxoo/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/account-invoicing/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/argentina-sale/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/partner/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/account-payment/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/reporting-engine/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/odoo-argentina/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/miscellaneous/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/argentina-reporting/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/sale/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/3-ingadhoc/product/requirements.txt
/usr/local/bin/pip install -U -r /home/odoo/odoodev10/source/3-ingadhoc/aeroo_reports/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/server-tools/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/reporting-engine/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/account-financial-reporting/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/report-print-send/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/community-data-files/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/stock-logistics-barcode/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/web/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/server-auth/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/connector/requirements.txt
/usr/local/bin/pip install -r /home/odoo/odoodev10/source/2-OCA/account-financial-tools/requirements.txt

