pushd $HOME
mkdir .zcash-params
curl https://download.z.cash/downloads/sapling-output.params --output .zcash-params/sapling-output.params
curl https://download.z.cash/downloads/sapling-spend.params --output .zcash-params/sapling-spend.params
popd

sed -e 's/rlib/cdylib/' < native/zcash-sync/Cargo.toml >/tmp/out.toml
mv /tmp/out.toml native/zcash-sync/Cargo.toml
