# shib-idp
This is a standalone idp container based on Shibboleth Idp training course - https://spaces.at.internet2.edu/display/ShibInstallFest/TIER+Shibboleth+IdP+Training+-+Linux+Installation
<br>
To setup it for my personal case, I did below changes for configuration.

1.  Add SP related AttributeFilterPolicy to idp/container_files/config/shib-idp/conf/attribute-filter.xml:
```
<AttributeFilterPolicy id="universe-42">
    <PolicyRequirementRule xsi:type="OR">
        <Rule xsi:type="Requester" value="http://saml.localhost" />
    </PolicyRequirementRule>
    
    <AttributeRule attributeID="surname">
        <PermitValueRule xsi:type="ANY" />
    </AttributeRule>
    
    <AttributeRule attributeID="givenName">
        <PermitValueRule xsi:type="ANY" />
    </AttributeRule>

    <AttributeRule attributeID="uid">
        <PermitValueRule xsi:type="ANY" />
    </AttributeRule>
    
    <AttributeRule attributeID="mail">
        <PermitValueRule xsi:type="ANY" />
    </AttributeRule>
</AttributeFilterPolicy>
```

2.  Alter friendlyName of some attributes in idp/container_files/config/shib-idp/conf/attribute-resolver.xml:
```
<AttributeEncoder xsi:type="SAML2String" name="urn:oid:0.9.2342.19200300.100.1.1" friendlyName="UID" encodeType="false" />
<AttributeEncoder xsi:type="SAML2String" name="urn:oid:0.9.2342.19200300.100.1.3" friendlyName="Email" encodeType="false" />
<AttributeEncoder xsi:type="SAML2String" name="urn:oid:2.5.4.4" friendlyName="Surname" encodeType="false" />
<AttributeEncoder xsi:type="SAML2String" name="urn:oid:2.5.4.42" friendlyName="Given Name" encodeType="false" />
```

3.  Change some options in idp/container_files/config/shib-idp/conf/idp.properties:
```
idp.entityID= https://127.0.0.1/idp/shibboleth
idp.scope= 127.0.0.1
idp.encryption.optional = true
idp.errors.detailed = true
idp.errors.signed = false
```

4.  Change idp/container_files/config/shib-idp/conf/logback.xml to output more logging info for debug purpose:
```
<logger name="org.opensaml" level="DEBUG"/>
```

5.  Add a sp metadata into idp/container_files/config/shib-idp/conf/metadata-providers.xml:
```
<MetadataProvider 
    id="LocalMetadata"  
    xsi:type="FilesystemMetadataProvider" 
    metadataFile="/opt/shibboleth-idp/metadata/sp_metadata.xml">
    <MetadataFilter xsi:type="EntityRoleWhiteList">
        <RetainedRole>md:SPSSODescriptor</RetainedRole>
    </MetadataFilter>
</MetadataProvider>
```

6.  Add nameId generateor into idp/container_files/config/shib-idp/conf/saml-nameid.xml:
```
<bean parent="shibboleth.SAML2AttributeSourcedGenerator"
    p:format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
    p:attributeSourceIds="#{ {'mail'} }" />
```

# Prerequsites
1. Docker
2. A brave heart

# Usage
1. git clone git@github.com:chinatsui/shib-idp.git
2. ./compose.sh