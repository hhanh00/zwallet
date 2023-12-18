echo $1

# Download params
mkdir /d/.zcash-params
curl https://download.z.cash/downloads/sapling-output.params --output /d/.zcash-params/sapling-output.params
curl https://download.z.cash/downloads/sapling-spend.params --output /d/.zcash-params/sapling-spend.params
cp /d/.zcash-params/* assets/

export HOME=/d/

git clone -b $1 --depth 1 https://github.com/flutter/flutter.git /d/flutter

flutter doctor -v
