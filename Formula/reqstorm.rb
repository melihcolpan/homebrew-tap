class Reqstorm < Formula
  include Language::Python::Virtualenv

  desc "Send thousands of HTTP requests with rate limits, retries and progress"
  homepage "https://reqstorm.github.io"
  url "https://files.pythonhosted.org/packages/2f/98/035873b2870a061c713159ecdd15694ddd0930a63347ad4e9b69d7a76b50/reqstorm-2.4.1.tar.gz"
  sha256 "c4814af54182ad8959f49e5483cc3ccde0a5e4011f0a14b391dd4b8beff04ae1"
  license "MIT"

  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/93/2f/6a91adaa2dc26877d6ed2f54c0370c8910f019db7d77c5c6a194611e93ea/aiohttp-3.14.4.tar.gz"
    sha256 "831fc5bd39ec2517851e348f613ddb5447a47cf4b71cb09845af7ad7ed45d8f9"
  end

  resource "aiohttp-socks" do
    url "https://files.pythonhosted.org/packages/18/1d/a306e0111222180e60f17131a3f5d9bc694dd999a8115959a7dd76c2238e/aiohttp_socks-0.12.0.tar.gz"
    sha256 "3caf9f5a4164611122d412bc11b2f9114fd29c85e1ba27bb38060d3c236bdc8d"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/99/1d4d69c3512d0ddbfa3a1b69cfd9a151012ab2eb4eabbb096201b1f0b7d8/multidict-6.9.1.tar.gz"
    sha256 "0f06e60fa190aa7abd0914c2a766736fdc8e9f34878c4346338534b73d1b20e2"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/b3/9a/9fbf4e4ec0c2d7f1c32519fff782ef467859b8faa9fbc5331a96f6395d43/propcache-0.5.4.tar.gz"
    sha256 "ff6b113f50bc066a698db5d944d2c6dc7507168dd3341e255a8892fd0715a558"
  end

  resource "python-socks" do
    url "https://files.pythonhosted.org/packages/04/ad/484ffb79532517b11a90af38647c38652224650b31a7ae1cedd5a418d8ab/python_socks-3.1.1.tar.gz"
    sha256 "8d3e817cdbe858dc0bb8c8fdc8e79b6ce37acce110d33374c6f57a675cc9029e"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reqstorm --version")
    assert_match "rate limits:", shell_output("#{bin}/reqstorm --help")
    (testpath/"urls.txt").write("http://127.0.0.1:9/\n")
    output = shell_output("#{bin}/reqstorm #{testpath}/urls.txt --timeout 2 -q 2>&1", 1)
    assert_match "ClientConnectorError", output
  end
end
