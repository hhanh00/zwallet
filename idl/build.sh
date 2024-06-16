flatc -d -r --gen-object-api data.fbs
mv data_fb_generated.dart ../packages/warp_api_ffi/lib
mv data_generated.rs ../native/zcash-sync/src/db

flatc -r --gen-object-api vote.fbs
mv vote_generated.rs ../native/zcash-sync/src/vote
