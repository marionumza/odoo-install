#!/bin/bash

#--------------------------------------------------
# Update Server
#--------------------------------------------------
echo -e "\n---- Update Server ----"
sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y
sudo apt-get install default-jre -y
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get install default-jdk -y
sudo apt-get update
sudo apt-get install oracle-java8-installer -y
sudo add-apt-repository -y ppa:mystic-mirage/pycharm
sudo apt-get update

echo -e "\n---- Install Virtualbox Guest Utils ----"
sudo apt-get install virtualbox-guest-x11-hwe -y



echo "Installazione Database Postgresql"
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
apt-get upgrade -y
apt-get install -y postgresql-9.6 postgresql-server-dev-9.6 pgadmin3 pgadmin4

echo -e "\n---- Install tool packages ----"
sudo apt-get install wget subversion git bzr bzrtools python3-pip gdebi-core -y

sudo apt-get install -y libsasl2-dev python-dev libldap2-dev libssl-dev python3-dev libxml2-dev libxslt1-dev zlib1g-dev python3-pip python3-wheel python3-setuptools python3-babel python3-bs4 python3-cffi-backend python3-cryptography python3-dateutil python3-docutils python3-feedparser python3-funcsigs python3-gevent python3-greenlet python3-html2text python3-html5lib python3-jinja2 python3-lxml python3-mako python3-markupsafe python3-mock python3-ofxparse python3-openssl python3-passlib python3-pbr python3-pil python3-psutil python3-psycopg2 python3-pydot python3-pygments python3-pyparsing python3-pypdf2 python3-renderpm python3-reportlab python3-reportlab-accel python3-roman python3-serial python3-stdnum python3-suds python3-tz python3-usb python3-vatnumber python3-werkzeug python3-xlsxwriter python3-yaml
sudo -H pip3 install --upgrade -r https://raw.githubusercontent.com/odoo/odoo/11.0/requirements.txt

wget https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.xenial_amd64.deb
gdebi --n wkhtmltox_0.12.5-1.xenial_amd64.deb

echo -e "\n---- Install python libraries ----"
# This is for compatibility with Ubuntu 16.04. Will work on 14.04, 15.04 and 16.04
sudo apt-get install python3-suds -y

echo -e "\n--- Install other required packages"
sudo apt-get install node-clean-css node-less python-gevent -y

#echo -e "\n--- Create symlink for node"
#sudo ln -s /usr/bin/nodejs /usr/bin/node

sudo pip3 install num2words ofxparse
sudo apt-get install nodejs npm node-less -y
#sudo npm install -g less
#sudo npm install -g less-plugin-clean-css	

	
	
echo "Installazione Odoo 11.0"
sudo -u postgres createuser -s odoo
sudo -u postgres psql -c "ALTER USER odoo WITH PASSWORD 'odoo';"
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'odoo';"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/OCB.git /home/odoo/odoodev11/server"
su - odoo -c "mkdir -p /home/odoo/odoodev11/addons"
su - odoo -c "git clone -b 11.0 https://github.com/OCA/reporting-engine /home/odoo/odoodev11/source/2-OCA/reporting-engine"
pip3 install --upgrade -r /home/odoo/odoodev11/source/2-OCA/reporting-engine/requirements.txt


sudo chown -R odoo:odoo /home/odoo/odoodev11/server
sudo chown -R odoo:odoo /opt/odoo
pip3 install geojson

echo "Installazione pyxb"
pip3 install pyxb==1.2.5

echo "Installazione codicefiscale"
pip3 install codicefiscale

echo "Installazione simplejson"
pip3 install simplejson

echo "Installazione unidecode"
pip3 install unidecode

echo "Installazione phonenumbers"
pip3 install phonenumbers

echo "Installazione numpy"
pip3 install numpy

su - odoo -c 'for d in $( ls odoodev11/source); do  find $(pwd)/odoodev11/source/$d -mindepth 2 -maxdepth 2 -type d -exec sh -c "ln -sfn \"{}\" $(pwd)/odoodev11/addons" \;; done'

su - odoo -c "/home/odoo/odoodev11/server/odoo-bin --stop-after-init -s -c /home/odoo/odoodev11/odoo_serverrc --db_host=localhost --db_user=odoo --db_password=odoo --addons-path=/home/odoo/odoodev11/server/odoo/addons,/home/odoo/odoodev11/server/addons,/home/odoo/odoodev11/addons"

echo -e "* Create init file"
su - odoo -c "mkdir bin"
su - odoo -c "cat <<EOF > ~/bin/odoo
#!/bin/sh
/home/odoo/odoodev11/server/odoo-bin -c /home/odoo/odoodev11/odoo.conf
EOF"
su - odoo -c "chmod 755 ~/bin/odoo"

echo "Installazione Aeroo"
mkdir /opt/aeroo
echo '#!/bin/sh' > /etc/init.d/office
echo '' >> /etc/init.d/office
echo '/usr/bin/soffice --nologo --nofirststartwizard --headless --norestore --invisible "--accept=socket,host=localhost,port=8100,tcpNoDelay=1;urp;" &'  >> /etc/init.d/office
chmod +x /etc/init.d/office
update-rc.d office defaults
/etc/init.d/office
pip3 install jsonrpc2 daemonize
git clone https://github.com/aeroo/aeroo_docs.git /opt/aeroo/aeroo_docs
cd /opt/aeroo/aeroo_docs/
echo "Y" | python3 /opt/aeroo/aeroo_docs/aeroo-docs start -c /etc/aeroo-docs.conf
ln -s /opt/aeroo/aeroo_docs/aeroo-docs /etc/init.d/aeroo-docs
update-rc.d aeroo-docs defaults

su - odoo -c "git clone -b 11.0 https://github.com/ingadhoc/aeroo_reports.git /home/odoo/odoodev11/source/3-ingadhoc/aeroo_reports"
pip3 install --upgrade -r /home/odoo/odoodev11/source/3-ingadhoc/aeroo_reports/requirements.txt


su - odoo -c "git clone -b 11.0 --single-branch https://github.com/ingadhoc/miscellaneous  /home/odoo/odoodev11/source/3-ingadhoc/miscellaneous"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/ingadhoc/odoo-argentina  /home/odoo/odoodev11/source/3-ingadhoc/odoo-argentina"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/ingadhoc/argentina-sale  /home/odoo/odoodev11/source/3-ingadhoc/argentina-sale"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/ingadhoc/argentina-reporting  /home/odoo/odoodev11/source/3-ingadhoc/argentina-reporting"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/ingadhoc/account-financial-tools  /home/odoo/odoodev11/source/3-ingadhoc/account-financial-tools"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/ingadhoc/reporting-engine  /home/odoo/odoodev11/source/3-ingadhoc/reporting-engine"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/ingadhoc/account-payment  /home/odoo/odoodev11/source/3-ingadhoc/account-payment"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/ingadhoc/partner  /home/odoo/odoodev11/source/3-ingadhoc/partner"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/ingadhoc/sale  /home/odoo/odoodev11/source/3-ingadhoc/sale"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/ingadhoc/account-invoicing  /home/odoo/odoodev11/source/3-ingadhoc/account-invoicing"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/ingadhoc/product  /home/odoo/odoodev11/source/3-ingadhoc/product"

su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/server-tools  /home/odoo/odoodev11/source/2-OCA/server-tools"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/server-ux  /home/odoo/odoodev11/source/2-OCA/server-ux"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/partner-contact  /home/odoo/odoodev11/source/2-OCA/partner-contact"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/l10n-italy  /home/odoo/odoodev11/source/2-OCA/l10n-italy"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/account-payment  /home/odoo/odoodev11/source/2-OCA/account-payment"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/account-financial-reporting  /home/odoo/odoodev11/source/2-OCA/account-financial-reporting"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/account-financial-tools  /home/odoo/odoodev11/source/2-OCA/account-financial-tools"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/account-closing  /home/odoo/odoodev11/source/2-OCA/account-closing"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/account-analytic  /home/odoo/odoodev11/source/2-OCA/account-analytic"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/account-invoicing  /home/odoo/odoodev11/source/2-OCA/account-invoicing"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/account-invoice-reporting  /home/odoo/odoodev11/source/2-OCA/account-invoice-reporting"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/account-budgeting /home/odoo/odoodev11/source/2-OCA/account-budgeting"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/account-consolidation /home/odoo/odoodev11/source/2-OCA/account-consolidation"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/bank-payment  /home/odoo/odoodev11/source/2-OCA/bank-payment"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/bank-statement-reconcile  /home/odoo/odoodev11/source/2-OCA/bank-statement-reconcile"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/bank-statement-import  /home/odoo/odoodev11/source/2-OCA/bank-statement-import"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/product-attribute  /home/odoo/odoodev11/source/2-OCA/product-attribute"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/product-variant /home/odoo/odoodev11/source/2-OCA/product-variant"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/stock-logistics-warehouse  /home/odoo/odoodev11/source/2-OCA/stock-logistics-warehouse"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/stock-logistics-tracking  /home/odoo/odoodev11/source/2-OCA/stock-logistics-tracking"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/stock-logistics-barcode  /home/odoo/odoodev11/source/2-OCA/stock-logistics-barcode"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/stock-logistics-workflow  /home/odoo/odoodev11/source/2-OCA/stock-logistics-workflow"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/stock-logistics-transport  /home/odoo/odoodev11/source/2-OCA/stock-logistics-transport"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/sale-workflow  /home/odoo/odoodev11/source/2-OCA/sale-workflow"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/sale-financial /home/odoo/odoodev11/source/2-OCA/sale-financial"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/sale-reporting /home/odoo/odoodev11/source/2-OCA/sale-reporting"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/web  /home/odoo/odoodev11/source/2-OCA/web"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/website  /home/odoo/odoodev11/source/2-OCA/website"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/event /home/odoo/odoodev11/source/2-OCA/event"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/survey /home/odoo/odoodev11/source/2-OCA/survey"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/social  /home/odoo/odoodev11/source/2-OCA/social"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/e-commerce  /home/odoo/odoodev11/source/2-OCA/e-commerce"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/commission /home/odoo/odoodev11/source/2-OCA/commission"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/margin-analysis  /home/odoo/odoodev11/source/2-OCA/margin-analysis"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/contract  /home/odoo/odoodev11/source/2-OCA/contract"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/rma  /home/odoo/odoodev11/source/2-OCA/rma"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/crm  /home/odoo/odoodev11/source/2-OCA/crm"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/project-service  /home/odoo/odoodev11/source/2-OCA/project-service"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/carrier-delivery  /home/odoo/odoodev11/source/2-OCA/carrier-delivery"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/stock-logistics-reporting /home/odoo/odoodev11/source/2-OCA/stock-logistics-reporting"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/hr-timesheet  /home/odoo/odoodev11/source/2-OCA/hr-timesheet"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/hr  /home/odoo/odoodev11/source/2-OCA/hr"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/management-system  /home/odoo/odoodev11/source/2-OCA/management-system"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/report-print-send  /home/odoo/odoodev11/source/2-OCA/report-print-send"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/purchase-reporting  /home/odoo/odoodev11/source/2-OCA/purchase-reporting"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/purchase-workflow  /home/odoo/odoodev11/source/2-OCA/purchase-workflow"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/manufacture-reporting  /home/odoo/odoodev11/source/2-OCA/manufacture-reporting"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/knowledge  /home/odoo/odoodev11/source/2-OCA/knowledge"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/project-reporting  /home/odoo/odoodev11/source/2-OCA/project-reporting"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/project  /home/odoo/odoodev11/source/2-OCA/project"

su - odoo -c "git clone -b 11.0 --single-branch https://github.com/it-projects-llc/misc-addons  /home/odoo/odoodev11/source/1-it-projects-llc/misc-addons"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/it-projects-llc/access-addons  /home/odoo/odoodev11/source/1-it-projects-llc/access-addons"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/it-projects-llc/pos-addons  /home/odoo/odoodev11/source/1-it-projects-llc/pos-addons"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/it-projects-llc/website-addons  /home/odoo/odoodev11/source/1-it-projects-llc/website-addons"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/it-projects-llc/mail-addons  /home/odoo/odoodev11/source/1-it-projects-llc/mail-addons"

su - odoo -c "git clone -b 11.0 --single-branch https://github.com/vauxoo/addons-vauxoo /home/odoo/odoodev11/source/5-vauxoo/addons-vauxoo"

su - odoo -c "git clone -b 11.0 --single-branch https://github.com/onesteinbv/addons-onestein  /home/odoo/odoodev11/source/5-onesteinbv/addons-onestein"

su - odoo -c "git clone -b 11.0 --single-branch https://github.com/initOS/openerp-dav /home/odoo/odoodev11/source/4-initOS/openerp-dav"

su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/connector /home/odoo/odoodev11/source/2-OCA/connector"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/queue /home/odoo/odoodev11/source/2-OCA/queue"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/multi-company  /home/odoo/odoodev11/source/2-OCA/multi-company"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/pos  /home/odoo/odoodev11/source/2-OCA/pos"

su - odoo -c "git clone -b 11.0 --single-branch https://github.com/fcoach66/odoo-italy-extra  /home/odoo/odoodev11/source/7-fcoach66/odoo-italy-extra"


su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/community-data-files  /home/odoo/odoodev11/source/2-OCA/community-data-files"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/geospatial  /home/odoo/odoodev11/source/2-OCA/geospatial"
su - odoo -c "git clone -b 11.0 --single-branch https://github.com/OCA/vertical-isp  /home/odoo/odoodev11/source/2-OCA/vertical-isp"


pip3 install -r /home/odoo/odoodev11/server/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/2-OCA/account-financial-tools/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/2-OCA/social/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/2-OCA/server-tools/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/2-OCA/partner-contact/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/2-OCA/report-print-send/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/2-OCA/stock-logistics-barcode/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/2-OCA/account-financial-reporting/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/2-OCA/bank-statement-import/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/2-OCA/web/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/2-OCA/reporting-engine/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/3-ingadhoc/account-invoicing/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/3-ingadhoc/odoo-argentina/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/3-ingadhoc/sale/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/3-ingadhoc/argentina-reporting/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/3-ingadhoc/partner/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/3-ingadhoc/product/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/3-ingadhoc/miscellaneous/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/3-ingadhoc/aeroo_reports/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/3-ingadhoc/reporting-engine/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/3-ingadhoc/argentina-sale/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/3-ingadhoc/account-payment/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/5-vauxoo/addons-vauxoo/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/1-it-projects-llc/misc-addons/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/1-it-projects-llc/pos-addons/requirements.txt
pip3 install -r /home/odoo/odoodev11/source/1-it-projects-llc/website-addons/requirements.txt

su - odoo -c 'for d in $( ls odoodev11/source); do  find $(pwd)/odoodev11/source/$d -mindepth 2 -maxdepth 2 -type d -exec sh -c "ln -sfn \"{}\" $(pwd)/odoodev11/addons" \;; done'

