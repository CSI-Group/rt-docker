Set($WebSecureCookies, 0);

### Base configuration ###
Set($rtname, 'rt');
Set($WebDomain, 'hd.csi.group'); #
Set($WebBaseURL, 'https://'.RT->Config->Get('WebDomain'));
# Set($WebPort, 8080);
Set($CanonicalizeRedirectURLs, 1);
Set($CanonicalizeURLsInFeeds, 1);

Set($Timezone, 'Europe/Moscow');
Set($DateTimeFormat, { Format => "ISO" });
Set($RTSupportEmail, 'it_dept@csi.group');

#Set($WebExternalAuth , 1);
#Set($WebFallbackToInternalAuth , 0);

Plugin('RT::Extension::MergeUsers');
Plugin('RT::Extension::TerminalTheme');

### Database connection ###
Set($DatabaseType, 'Pg' );
Set($DatabaseHost, 'db');
Set($DatabasePort, '5432');
Set($DatabaseUser, 'rt');
Set($DatabasePassword, 'password');
Set($DatabaseName, 'rt');
Set($DatabaseAdmin, "rt");

Set($SendmailPath, '/usr/bin/msmtp');

# docker compose -f docker-compose.yml run --rm rt bash -c 'cd /opt/rt5 && perl /opt/rt5/sbin/rt-setup-fulltext-index
Set( %FullTextSearch,
    Enable     => 1,
    Indexed    => 1,
    Table      => 'AttachmentsIndex',
    Column     => 'ContentIndex',
);

### GnuPG configuration ###
Set(%GnuPG,
  Enable                 => 0,
  GnuPG                  => 'gpg',
  Passphrase             => undef,
  OutgoingMessagesFormat => 'RFC'
);

Set(%GnuPGOptions,
  homedir             => '/opt/rt5/var/data/gpg',
  passphrase          => 'PASSPHRASE',
  keyserver           => 'hkps://keys.openpgp.org',
  'keyserver-options' => 'auto-key-retrieve timeout=20',
  'auto-key-locate'   => 'keyserver',
);

### SMIME configuration ###
Set(%SMIME,
    Enable             => 0,
    AcceptUntrustedCAs => 1,
    OpenSSL            => '/usr/bin/openssl',
    Keyring            => '/opt/rt5/var/data/smime',
    CAPath             => '/opt/rt5/var/data/smime/signing-ca.pem',
    Passphrase => {
        'user@user.com' => 'PASSPHRASE',
        ''              => 'fallback',
    },
);

### OAuth2 configuration ###
Plugin('RT::Authen::OAuth2');
Set($EnableOAuth2, 1);
Set($OAuthCreateNewUser, 1);
Set($OAuthNewUserOptions, {
            Privileged => 0,
        },
);

#Set($OAuthRedirect, '');
Set($OAuthIDP, 'kc');


Set(%OAuthIDPSecrets,
    'kc' => {
        'client_id' => '31219175-2760-4394-b646-55eccd078da0',
        'client_secret' => 'nZX_Xcqx3c2ZpOXmd-rW3ep66_0OPkbSEanj3dqK',
    },
);


Set(%OAuthIDPs,
    'kc' => {
        # You must Set($Auth0Host, "something.auth0.com");
        'MetadataHandler' => 'RT::Authen::OAuth2::Google',
        'MetadataMap' => {
            EmailAddress => 'email',
            RealName => 'name',
            NickName => 'nickname',
            Lang => 'not-provided',
            Organization => 'company',
            VerifiedEmail => 'email_verified',
            # Department => 'departpment',
            WorkPhone => 'phoneNumber',
        },
        'LoginPageButton' => '/static/images/btn_auth0_signin.png',
        'site' => 'https://kc.csi.group',
        'authorize_path' => '/realms/RT/protocol/openid-connect/auth',
        'access_token_path' => '/realms/RT/protocol/openid-connect/token',
        'logout_path' => '/realms/RT/protocol/openid-connect/logout?post_logout_redirect_uri=https://hd.csi.group&client_id='.
            RT->Config->Get('OAuthIDPSecrets')->{kc}->{client_id},
        'protected_resource_path' => '/realms/RT/protocol/openid-connect/userinfo',
        'name' => 'kc',
        'scope' => 'openid profile email',
        'state' => '',
    }
);

1;
