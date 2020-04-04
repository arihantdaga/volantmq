## TODO: 
## Give debug flag optional. 

GOOS=linux 
VOLANTMQ_WORK_DIR=/usr/lib/volantmq 
VOLANTMQ_BUILD_FLAGS="-i " 
VOLANTMQ_PLUGINS_DIR=/usr/lib/volantmq/plugins 
GO111MODULE=on
DEBUG_FLAGS=""

mkdir -p $VOLANTMQ_WORK_DIR/bin
mkdir -p $VOLANTMQ_WORK_DIR/conf
mkdir -p $VOLANTMQ_PLUGINS_DIR
PATH=$VOLANTMQ_WORK_DIR/bin:$PATH

# TODO: DO It separately and run using sudo and then modify the permission. 
cp $GOPATH/src/github.com/VolantMQ/volantmq/tools/print_version.sh /bin

# build server
echo "Building Server"
    #TODO: I am not sure why this happens but with GO11MODULEOFF it throws error for mpb/v4
    # GO111MODULE=off go get -v github.com/VolantMQ/volantmq/cmd/volantmq && \ 
    cd $GOPATH/src/github.com/VolantMQ/volantmq/cmd/volantmq \
    && GO111MODULE=on go mod tidy \
    && go get github.com/troian/govvv \
    && govvv build -gcflags='all=-N -l' $VOLANTMQ_BUILD_FLAGS -o $VOLANTMQ_WORK_DIR/bin/volantmq

cp $GOPATH/src/github.com/VolantMQ/volantmq/tools/print_version.sh /bin

# build debug plugins
echo "Building Debug PLugin"
    GO111MODULE=off go get gitlab.com/VolantMQ/vlplugin/debug \
    && cd $GOPATH/src/gitlab.com/VolantMQ/vlplugin/debug \
    && GO111MODULE=on go mod tidy \
    && go build -x -gcflags='all=-N -l' $VOLANTMQ_BUILD_FLAGS -buildmode=plugin -ldflags "-X main.version=$(print_version.sh)" -o $VOLANTMQ_WORK_DIR/plugins/debug.so

# build health plugins
echo "Building Health Plugin"
    GO111MODULE=off go get gitlab.com/VolantMQ/vlplugin/health \
    && cd $GOPATH/src/gitlab.com/VolantMQ/vlplugin/health \
    && GO111MODULE=on go mod tidy \
    && go build -gcflags='all=-N -l' $VOLANTMQ_BUILD_FLAGS -buildmode=plugin -ldflags "-X main.version=$(print_version.sh)" -o $VOLANTMQ_WORK_DIR/plugins/health.so

# build metrics plugins
echo "Building Metrics Plugin (Prometheus)"
       GO111MODULE=off go get gitlab.com/VolantMQ/vlplugin/monitoring/prometheus \
    && cd $GOPATH/src/gitlab.com/VolantMQ/vlplugin/monitoring/prometheus \
    && GO111MODULE=on go mod tidy \
    && go build -gcflags='all=-N -l' $VOLANTMQ_BUILD_FLAGS -buildmode=plugin -ldflags "-X main.version=$(print_version.sh)" -o $VOLANTMQ_WORK_DIR/plugins/prometheus.so

echo "Building Metrics Plugin (Systree)"
    GO111MODULE=off go get gitlab.com/VolantMQ/vlplugin/monitoring/systree \
    && cd $GOPATH/src/gitlab.com/VolantMQ/vlplugin/monitoring/systree \
    && GO111MODULE=on go mod tidy \
    && go build -gcflags='all=-N -l' $VOLANTMQ_BUILD_FLAGS -buildmode=plugin -ldflags "-X main.version=$(print_version.sh)" -o $VOLANTMQ_WORK_DIR/plugins/systree.so

#build persistence plugins
echo "Building Persistence Plugin"
    GO111MODULE=off go get gitlab.com/VolantMQ/vlplugin/persistence/bbolt \
    && cd $GOPATH/src/gitlab.com/VolantMQ/vlplugin/persistence/bbolt \
    && GO111MODULE=on go mod tidy \
    && cd plugin \
    && go build -gcflags='all=-N -l' $VOLANTMQ_BUILD_FLAGS -buildmode=plugin -ldflags "-X main.version=$(print_version.sh)" -o $VOLANTMQ_WORK_DIR/plugins/persistence_bbolt.so

#build auth plugins
echo "Building Auth Plugin (http)"
    GO111MODULE=off go get gitlab.com/VolantMQ/vlplugin/auth/http \
    && cd $GOPATH/src/gitlab.com/VolantMQ/vlplugin/auth/http \
    && GO111MODULE=on go mod tidy \
    && go build -gcflags='all=-N -l' $VOLANTMQ_BUILD_FLAGS -buildmode=plugin -ldflags "-X main.version=$(print_version.sh)" -o $VOLANTMQ_WORK_DIR/plugins/auth_http.so

