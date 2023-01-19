package smart.garbage.cot.util;

import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWSVerifier;
import com.nimbusds.jose.crypto.RSASSAVerifier;
import com.nimbusds.jwt.JWT;
import com.nimbusds.jwt.JWTParser;
import com.nimbusds.jwt.SignedJWT;
import org.eclipse.microprofile.config.Config;
import org.eclipse.microprofile.config.ConfigProvider;
import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerRequestFilter;
import jakarta.ws.rs.container.PreMatching;
import jakarta.ws.rs.core.*;
import jakarta.ws.rs.ext.Provider;
import jakarta.ws.rs.core.Response;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.*;
import java.security.interfaces.RSAPublicKey;
import java.text.ParseException;
import java.util.Arrays;

@Provider
@PreMatching // indicate that the filter will be applied globally to all resources
public class AuthenticationFilter implements ContainerRequestFilter {// AuthenticationFilter will block requests that do not contain JWT in their header
    public final static String XSS_COOKIE_NAME = "xssCookie";
    // the following paths will later be set to not be blocked by the filter since they represent the signin and signup with oauth pkce paths. JWT can only be obtained after the signin
    public final static String authorizePath = "/api/authorize";
    public final static String authenticatePath = "/api/authenticate/";
    public final static String authenticateadminPath = "/api/authenticateadmin/";
    public final static String tokenPath = "/api/oauth/token";
    public final static String personpath= "/api/user";
    public final static String forgottenpasswordpath= "/api/mail/";




    @Override
    public void filter(ContainerRequestContext containerRequestContext) throws IOException {
        String authorizationHeader = containerRequestContext.getHeaderString(HttpHeaders.AUTHORIZATION); // get the access token from the authorization header
        final String path = containerRequestContext.getUriInfo().getRequestUri().getPath(); // get path of the request
        if(path.equals(authorizePath)||path.contains(tokenPath)||path.equals(authenticatePath)||path.equals(personpath)||path.equals(authenticateadminPath)||path.contains(forgottenpasswordpath)){
            return; // if the request path is equal to the signin or signup paths, the request is allowed  without an access token
        }
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) { // access tokens  are sent in the headers with a prefix of Bearer
            String authenticationToken = authorizationHeader.substring(7); // get the access token from the header by taking the part after the prefix Bearer
            if (checkToken(authenticationToken)){
                return;}// Verify the signature  and time validity of token, if they are valid allow the request
            else{containerRequestContext.abortWith(Response
                    .status(Response.Status.UNAUTHORIZED)
                    .entity("User cannot access the resource.")
                    .build());} // if the jwt is not valid, block the request

        }
        //  if the paths do not coresspond and the user did not send a header containing the access token, block the request.
        else{containerRequestContext.abortWith(Response
                .status(Response.Status.UNAUTHORIZED)
                .entity("User cannot access the resource.")
                .build());}


    }
    private static final Config config = ConfigProvider.getConfig();
    static {
        //acquire the public key which is necessary for the verification of tokens
        FileInputStream fis = null;
        char[] password = config.getValue("jwtSecret",String.class).toCharArray();
        String alias = config.getValue("jwtAlias",String.class);
        PrivateKey pk = null;
        PublicKey pub = null;
        try {
            KeyStore ks = KeyStore.getInstance("JKS");
            String configDir = System.getProperty("jboss.server.config.dir");
            String keystorePath = configDir + File.separator + "jwt.jks";
            fis = new FileInputStream(keystorePath);
            ks.load(fis, password);
            Key key = ks.getKey("jwt", password);
            if (key instanceof PrivateKey) {
                pk = (PrivateKey) key;
                // Get certificate of public key
                java.security.cert.Certificate cert = ks.getCertificate(alias);
                pub = cert.getPublicKey();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (fis != null) {
                try {
                    fis.close();
                } catch (IOException ignored) {}
            }
        }
        privateKey = pk;
        publicKey = pub;
    }
    private static final PrivateKey privateKey;
    static final PublicKey publicKey;
    static final String ISSUER = config.getValue("jwtIssuer",String.class);
    static final String AUDIENCE = config.getValue("jwtAudience",String.class);
    private Boolean checkToken(String token){ // check the validity of tokens
        SignedJWT signedJWT;
        try {
            signedJWT = SignedJWT.parse(token);
            JWSVerifier verifier = new RSASSAVerifier((RSAPublicKey)publicKey);
            if(!signedJWT.verify(verifier)){//verify with the public key the signature of the token
                return false;
            }
            JWT jwt = JWTParser.parse(token);
            long currentTime = System.currentTimeMillis(); // get current time
            if( jwt.getJWTClaimsSet().getIssuer().equals(ISSUER) && // verify issuer and audience and compare expiration time with current time
                    jwt.getJWTClaimsSet().getAudience().containsAll(Arrays.asList(AUDIENCE)) && jwt.getJWTClaimsSet().getExpirationTime().getTime()>currentTime){
                return true;
            }
            return false;
        } catch (ParseException | JOSEException e) {
            return false;
        }
    }
}
