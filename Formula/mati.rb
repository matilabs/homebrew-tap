# The `mati` command, installed from the signed binaries the release publishes.
#
# This is a binary formula: Homebrew downloads a prebuilt executable rather than
# building from source, because the source is not public. What makes that safe
# is the signature, not the URL. Every artifact is signed with minisign at
# release time, and `install` verifies the detached signature against the key
# embedded in the product itself before anything reaches the prefix. A download
# that does not verify fails the install rather than landing.
#
# Homebrew's own sha256 below catches a corrupted download and a swapped file.
# The minisign check catches the case the hash cannot: somebody who could write
# to both the bucket and this formula.
class Mati < Formula
  desc "Local orchestrator for coding agent sessions"
  homepage "https://mati.nzk.com.br"
  version "0.5.0-beta.1-651-g9f2ba291"
  license :cannot_represent

  depends_on "minisign" => :build
  depends_on :macos

  # The key the product embeds and its own updater verifies against, so the
  # install path and the update path trust exactly the same signer.
  MINISIGN_PUBLIC_KEY = "RWTvkzdnWZvTWn5Gk+AF27dZUdrm9SpoHUo6hXuejdt+rUpcPqjpHpYG"
  BASE = "https://mati.nzk.com.br/beta/v0.5.0-beta.1-651-g9f2ba291"

  on_arm do
    url "#{BASE}/mati-darwin-arm64"
    sha256 "8aa9fcbff91ebe8354e7478191cc5c5a0606c6935b42babc6b72290f72ef09a0"
  end

  on_intel do
    url "#{BASE}/mati-darwin-amd64"
    sha256 "728ce2a55abbf1b078ab0f8c4632e3de20e201d4fb7c03af19df7c08a20582ba"
  end

  def install
    binary = Hardware::CPU.arm? ? "mati-darwin-arm64" : "mati-darwin-amd64"
    downloaded = Pathname.pwd/binary
    downloaded = Pathname.pwd/File.basename(cached_download) unless downloaded.exist?

    # Fetch the detached signature beside the artifact and verify before install.
    # Fail closed: no signature, or one that does not check out, stops here.
    signature = Pathname.pwd/"#{binary}.minisig"
    system "curl", "-fsSL", "-o", signature, "#{BASE}/#{binary}.minisig"
    system "minisign", "-V", "-P", MINISIGN_PUBLIC_KEY, "-x", signature, "-m", downloaded

    bin.install downloaded => "mati"
    chmod 0755, bin/"mati"
  end

  def caveats
    <<~EOS
      The daemon runs on its own and outlives every client. Set it up to start
      at login with:
        mati daemon install
    EOS
  end

  test do
    assert_match "darwin", shell_output("#{bin}/mati version")
  end
end
