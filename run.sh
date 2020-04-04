export VOLANTMQ_WORK_DIR=/usr/lib/volantmq 
export VOLANTMQ_PLUGINS_DIR=/usr/lib/volantmq/plugins 
export VOLANTMQ_CONFIG=$(pwd)/config.local.yaml
if test -f "$VOLANTMQ_CONFIG"; then
echo "Local config file exists"
else
cp $(pwd)/examples/config.yaml config.local.yaml
fi

PATH=$VOLANTMQ_WORK_DIR/bin:$PATH
## Start broker
volantmq
