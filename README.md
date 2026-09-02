# MatiAI, on Homebrew

The `mati` command and the MatiAI desktop app.

```sh
brew tap matilabs/tap https://gitlab.com/matilabs/homebrew-tap.git
brew install matilabs/tap/mati        # the command
brew install --cask matilabs/tap/mati # the app
```

The URL is needed on the first command because this tap lives on GitLab, and
Homebrew's short form assumes GitHub. After that, the short name works.

## What gets installed

Prebuilt binaries, not a build from source. Every artifact is signed with
minisign at release time, and the formula verifies the detached signature
against the key the product itself embeds before anything lands in the prefix.
An artifact that does not verify stops the install.

## Channels

The formula tracks the beta channel today. The published manifests live at
`https://mati.nzk.com.br`.
