class Embed < Formula
  desc "CLI tool for Embeddable API - manage database connections, environments, and dashboards"
  homepage "https://github.com/embeddable-hq/embeddable-cli"
  # GitHub release URL
  url "https://github.com/embeddable-hq/embeddable-cli/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "7d1f906314e26c1fbe1d85dde3a9267c311fc67082a8c9561a79bf64dd8224e1"
  
  # For local testing, use:
  # url "file:///Users/eone/projects/embeddable-cli/embeddable-cli-v0.1.0.tar.gz"
  # sha256 "06b2ce5eb0d1a367f5fb49b47f6d6a9f18e6cd43c8556b545c24b7553b8138cd"
  license "MIT"

  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "node"

  def install
    system "pnpm", "install"
    system "pnpm", "build"
    
    # Install the CLI
    libexec.install Dir["*"]
    
    # Create wrapper script
    (bin/"embed").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/cli.js" "$@"
    EOS
    
    # Make the wrapper executable
    chmod 0755, bin/"embed"
  end

  test do
    assert_match "Embeddable CLI v#{version}", shell_output("#{bin}/embed version")
  end
end
