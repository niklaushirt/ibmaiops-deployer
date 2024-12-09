#while true; do oc port-forward statefulset/$(oc get statefulset | grep iaf-system-elasticsearch-es-aiops | awk '{print $1}') 9200; done
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT MODIFY BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

echo "         ________  __  ___     ___    ________       "     
echo "        /  _/ __ )/  |/  /    /   |  /  _/ __ \____  _____"
echo "        / // __  / /|_/ /    / /| |  / // / / / __ \/ ___/"
echo "      _/ // /_/ / /  / /    / ___ |_/ // /_/ / /_/ (__  ) "
echo "     /___/_____/_/  /_/    /_/  |_/___/\____/ .___/____/  "
echo "                                           /_/            "
echo ""
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  IBMAIOPS Dump LAGS MODELS Indexes"
echo ""
echo "***************************************************************************************************************************************************"






#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT MODIFY BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

export APP_NAME=robot-shop
export INDEX_TYPE=goldensignal
export WORKING_DIR="./DUMP/$APP_NAME/$INDEX_TYPE/$(date +%s)"

# Get Namespace from Cluster 
echo "   ------------------------------------------------------------------------------------------------------------------------------"
echo "   🔬 Getting Installation Namespace"
echo "   ------------------------------------------------------------------------------------------------------------------------------"

export AIOPS_NAMESPACE=$(oc get po -A|grep aiops-orchestrator-controller |awk '{print$1}')
echo "       ✅ OK - IBMAIOps:    $AIOPS_NAMESPACE"



oc project $AIOPS_NAMESPACE

#--------------------------------------------------------------------------------------------------------------------------------------------
#  Get Credentials
#--------------------------------------------------------------------------------------------------------------------------------------------

echo "***************************************************************************************************************************************************"
echo "  🔐  Getting credentials"
echo "***************************************************************************************************************************************************"

export username=$(oc exec -n $AIOPS_NAMESPACE -it iaf-system-elasticsearch-es-aiops-0 -- bash -c 'cat /usr/share/elasticsearch/config/user/username')	
export password=$(oc exec -n $AIOPS_NAMESPACE -it iaf-system-elasticsearch-es-aiops-0 -- bash -c 'cat /usr/share/elasticsearch/config/user/password')	


export WORKING_DIR_ES="./tools/02_training/TRAINING_FILES/ELASTIC/$APP_NAME/$INDEX_TYPE"


echo "      ✅ OK"
echo ""
echo ""



#--------------------------------------------------------------------------------------------------------------------------------------------
#  Check Credentials
#--------------------------------------------------------------------------------------------------------------------------------------------

echo "***************************************************************************************************************************************************"
echo "  🔗  Checking credentials"
echo "***************************************************************************************************************************************************"

if [[ $username == "" ]] ;
then
      echo "❌ Could not get Elasticsearch Username. Aborting..."
      exit 1
else
      echo "      ✅ OK - Elasticsearch Username"
fi

if [[ $password == "" ]] ;
then
      echo "❌ Could not get Elasticsearch Password. Aborting..."
      exit 1
else
      echo "      ✅ OK - Elasticsearch Password"
fi



echo ""
echo ""
echo ""
echo ""

echo "***************************************************************************************************************************************************"
echo "  "
echo "   🔎  Dumping LAGS MODELS indexes"
echo "  "
echo "           Data Files  : $WORKING_DIR"
echo "  "
echo "           User        : $username"
echo "           Password    : $password"
echo "  "
echo "***************************************************************************************************************************************************"



export existingIndexes=$(curl -k -u $username:$password -XGET https://localhost:9200/_cat/indices) 


if [[ $existingIndexes == "" ]] ;
then
    echo "❗ Please start port forward in separate terminal."
    echo "❗ Run the following:"
    echo "    while true; do oc port-forward statefulset/$(oc get statefulset | grep iaf-system-elasticsearch-es-aiops | awk '{print $1}') 9200; done"
    echo "❌ Aborting..."
    exit 1
fi


echo "   ✅  OK"


mkdir -p $WORKING_DIR
rm $WORKING_DIR/*.json

export NODE_TLS_REJECT_UNAUTHORIZED=0

echo "***************************************************************************************************************************************************"
echo "   🔎  LAGS MODELS indexes"
echo "***************************************************************************************************************************************************"

for index in $(curl -k -u $username:$password -XGET https://localhost:9200/_cat/indices | sort | grep "la_golden_signals-models" | awk '{print $3}'); 
do
  echo "***************************************************************************************************************************************************"
  echo "   💾  Dumping Index ${index}.json"
  read -p "Start Dump (otherwise skip this index)? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
      elasticdump --input=https://$username:$password@localhost:9200/${index} --limit=5000 --output="$WORKING_DIR/${index}_all.json" --type=data; 
      elasticdump --input=https://$username:$password@localhost:9200/${index} --limit=5000 --output="$WORKING_DIR/${index}_enabled.json" --type=data --searchBody='{"query": {"bool": {"must": {"term" : { "enabled" : "true" }}}}}'; 
      elasticdump --input=https://$username:$password@localhost:9200/${index} --limit=5000 --output="$WORKING_DIR/${index}_disabled.json" --type=data --searchBody='{"query": {"bool": {"must": {"term" : { "enabled" : "false" }}}}}'; 
  else
    echo "❌ Skipped"
  fi

done


     


echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " ✅  DONE: IBMAIOPS Dump LAGS MODELS Indexes"
echo ""
echo "***************************************************************************************************************************************************"


