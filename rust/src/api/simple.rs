use flutter_rust_bridge::frb;

pub async fn create_election(filepath: String, urls: String, key: String) -> anyhow::Result<Election> {
    // TODO: Split urls
    let e: zcash_vote::election::Election = reqwest::get(&urls).await?.json().await?;
    let e = Election {
        name: e.name,
        start_height: e.start_height,
        end_height: e.end_height,
        question: e.question,
        candidates: e.candidates.into_iter().map(|c| c.choice).collect(),
        signature_required: e.signature_required,
    };
    Ok(e)
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

#[frb(dart_metadata=("freezed"))]
pub struct Election {
    pub name: String,
    pub start_height: u32,
    pub end_height: u32,
    pub question: String,
    pub candidates: Vec<String>,
    pub signature_required: bool,
}
