require 'formula'

class Alpine <Formula
  url 'ftp://ftp.cac.washington.edu/alpine/alpine-2.00.tar.gz'
  homepage 'http://www.washington.edu/alpine/'
  md5 '0f4757167baf5c73aa44f2ffa4860093'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--with-ssl-include-dir=/usr/include/openssl"
    ENV.j1
    system "make install"
  end

  def patches
    DATA
    # The MAC_OSX_KLUDGE macro should *not* be set for 10.6 
    #  see: http://mailman2.u.washington.edu/pipermail/alpine-info/2009-October/002634.html
  end
end

__END__
--- alpine-2.00/imap/Makefile	2008-06-04 11:43:35.000000000 -0700
+++ my-alpine-2.00/imap/Makefile	2010-03-15 15:14:29.000000000 -0700
@@ -414,12 +414,19 @@ osi:	an
 	$(BUILD) BUILDTYPE=osx IP=$(IP6) CC=arm-apple-darwin-gcc \
 	SPECIALS="SSLINCLUDE=/usr/include/openssl SSLLIB=/usr/lib SSLCERTS=/System/Library/OpenSSL/certs SSLKEYS=/System/Library/OpenSSL/private"
 
-oxp:	an
-	$(TOUCH) ip6
-	$(BUILD) BUILDTYPE=osx IP=$(IP6) EXTRAAUTHENTICATORS="$(EXTRAAUTHENTICATORS) gss" \
-	PASSWDTYPE=pam \
-	EXTRACFLAGS="$(EXTRACFLAGS) -DMAC_OSX_KLUDGE=1" \
-	SPECIALS="SSLINCLUDE=/usr/include/openssl SSLLIB=/usr/lib SSLCERTS=/System/Library/OpenSSL/certs SSLKEYS=/System/Library/OpenSSL/private GSSINCLUDE=/usr/include GSSLIB=/usr/lib PAMDLFLAGS=-lpam"
+oxp: an
+		@$(SH) -c '(test ! -f /usr/include/pam/pam_appl.h ) || make osxpamkludge'
+		$(TOUCH) ip6
+		$(BUILD) BUILDTYPE=osx IP=$(IP6) EXTRAAUTHENTICATORS="$(EXTRAAUTHENTICATORS) gss" \
+		PASSWDTYPE=pam \
+		SPECIALS="SSLINCLUDE=/usr/include/openssl SSLLIB=/usr/lib SSLCERTS=/System/Library/OpenSSL/certs SSLKEYS=/System/Library/OpenSSL/private GSSINCLUDE=/usr/include GSSLIB=/usr/lib PAMDLFLAGS=-lpam"
+
+osxpamkludge:
+		@echo Building for pre-Mac OSX Snow Leopard
+		$(BUILD) BUILDTYPE=osx IP=$(IP6) EXTRAAUTHENTICATORS="$ (EXTRAAUTHENTICATORS) gss" \
+		EXTRACFLAGS="$(EXTRACFLAGS) -DMAC-OSX_KLUDGE=1"\
+		PASSWDTYPE=pam \
+		SPECIALS="SSLINCLUDE=/usr/include/openssl SSLLIB=/usr/lib SSLCERTS=/ System/Library/OpenSSL/certs SSLKEYS=/System/Library/OpenSSL/private GSSINCLUDE=/usr/include GSSLIB=/usr/lib PAMDLFLAGS=-lpam"
 
 osx:	osxok an
 	$(TOUCH) ip6