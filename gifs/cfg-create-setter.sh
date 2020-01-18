#!/bin/bash
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

########################
# include the magic
########################
. ../demos/demo-magic/demo-magic.sh

cd $(mktemp -d)
git init

stty rows 90 cols 20

export PKG=git@github.com:GoogleContainerTools/kpt.git/package-examples/helloworld-set@v0.1.0
kpt pkg get $PKG helloworld > /dev/null
git add . > /dev/null
git commit -m 'fetched helloworld' > /dev/null
kpt svr apply -R -f helloworld > /dev/null

# start demo
clear

echo "# start with helloworld package"
echo "$ kpt pkg desc helloworld"
kpt pkg desc helloworld

# start demo
echo " "
p "# 'kpt cfg create-setter' creates a new field setter by annotating Resource fields"
p "# create-setter takes as arguments the package dir, name of the setter to create and"
p "# current field value, and takes as a flag the field name"
pe "kpt cfg list-setters helloworld"
pe "kpt cfg create-setter helloworld service-type LoadBalancer --field type"
pe "kpt cfg list-setters helloworld"

echo " "
p "# 'kpt cfg set' invokes a setter, replacing current partial or full field values with"
p "# the user provided value"
pe "kpt cfg set helloworld replicas 7"
p "# listing the setters after they are set will show the upated values"
pe "kpt cfg list-setters helloworld"

echo " "
p "# setters may annotate field values with metadata about who set the value and"
p "# with a description of why the value was chosen"
pe "kpt cfg set helloworld replicas 3 --description 'good value for a demo' --set-by 'pwittrock' "
p "# listing the setters will display the field metadata"
pe "kpt cfg list-setters helloworld"

p "# for more information see 'kpt help cfg tree'"
p "kpt help cfg set"
