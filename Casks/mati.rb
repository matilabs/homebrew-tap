cask "mati" do
  arch arm: "-arm64", intel: ""

  version "0.5.0-beta.1-651-g9f2ba291"
  sha256 arm:   "b6e7613a8e715588421021cf4a487a0a375f01432dc6e13ef66cfcf57e2e2d75",
         intel: "ad5da0886fa7086a5e69bc1470cc746b37b6842de44d84030e82ba84c061ad8f"

  url "https://mati.nzk.com.br/app/beta/MatiAI-#{version}#{arch}.dmg"
  name "MatiAI"
  desc "Orchestrator for coding agent sessions, terminals and worktrees"
  homepage "https://mati.nzk.com.br"

  livecheck do
    url "https://mati.nzk.com.br/app/beta/beta-mac.yml"
    strategy :electron_builder
  end

  # The app updates itself: it reads the same channel manifest this cask points
  # at and swaps its own bundle in place. Saying so keeps Homebrew from racing
  # that, so `brew upgrade` leaves it alone unless somebody asks with --greedy,
  # and brew's idea of the version does not drift from what the app is actually
  # running.
  auto_updates true
  depends_on macos: ">= :big_sur"

  app "MatiAI.app"

  # Everything the app creates while it is used, so `brew uninstall --zap` is a
  # clean slate. The state directory holds the store, the journal and the
  # checkout registry; the rest is what Electron and macOS put there.
  zap trash: [
    "~/.mati",
    "~/Library/Application Support/MatiAI",
    "~/Library/Caches/br.com.nzk.mati",
    "~/Library/Caches/br.com.nzk.mati.ShipIt",
    "~/Library/HTTPStorages/br.com.nzk.mati",
    "~/Library/Preferences/br.com.nzk.mati.plist",
    "~/Library/Saved Application State/br.com.nzk.mati.savedState",
  ]
end
