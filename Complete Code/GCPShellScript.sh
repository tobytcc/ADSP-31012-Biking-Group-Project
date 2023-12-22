
# Creating a MySQL instance
gcloud services enable sqladmin.googleapis.com
gcloud sql instances create depa-bikes --tier=db-f1-micro --region=us-central1 --database-version=MYSQL_5_7
gcloud sql users set-password root --host=% --instance=depa-bikes --password="RootRoot"
gcloud sql instances patch depa-bikes --authorized-networks=0.0.0.0/0

# Adding a remote IP to MySQL instance
INSTANCE_NAME="depa-bikes"
NEW_IP="0.0.0.0/0"
CURRENT_IPs=$(gcloud sql instances describe $INSTANCE_NAME --format="value(settings.ipConfiguration.authorizedNetworks[].value)" | tr '\n' ',' | sed 's/,$//')
UPDATED_IPs="$CURRENT_IPs,$NEW_IP"
gcloud sql instances patch $INSTANCE_NAME --authorized-networks="$UPDATED_IPs"

# Getting connection IP address for GCloud MySQL instance
pip install mysql-connector-python
gcloud sql instances describe "depa-bikes" --format="get(ipAddresses.ipAddress)"


