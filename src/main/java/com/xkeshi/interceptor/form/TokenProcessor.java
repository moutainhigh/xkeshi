package com.xkeshi.interceptor.form;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
/**
 * 
 * @author xk
 * token  创建与销毁管理
 * @since 参考Struts 1.1
 */
public class TokenProcessor {
	
	private static final String TRANSACTION_TOKEN_KEY = "_transaction_token_";
	private static final String TOKEN_KEY = "_avoid_duplicate_token";
	
	/**
     * The singleton instance of this class.
     */
    private static TokenProcessor instance = new TokenProcessor();

    /**
     * Retrieves the singleton instance of this class.
     */
    public static TokenProcessor getInstance() {
        return instance;
    }

    /**
     * Protected constructor for TokenProcessor.  Use TokenProcessor.getInstance()
     * to obtain a reference to the processor.
     */
    protected TokenProcessor() {
        super();
    }

    /**
     * Return <code>true</code> if there is a transaction token stored in
     * the user's current session, and the value submitted as a request
     * parameter with this action matches it.  Returns <code>false</code>
     * under any of the following circumstances:
     * <ul>
     * <li>No session associated with this request</li>
     * <li>No transaction token saved in the session</li>
     * <li>No transaction token included as a request parameter</li>
     * <li>The included transaction token value does not match the
     *     transaction token in the user's session</li>
     * </ul>
     *
     * @param request The servlet request we are processing
     */
    public synchronized boolean isTokenValid(HttpServletRequest request) {
        return this.isTokenValid(request, false);
    }

    /**
     * Return <code>true</code> if there is a transaction token stored in
     * the user's current session, and the value submitted as a request
     * parameter with this action matches it.  Returns <code>false</code>
     * <ul>
     * <li>No session associated with this request</li>
     * <li>No transaction token saved in the session</li>
     * <li>No transaction token included as a request parameter</li>
     * <li>The included transaction token value does not match the
     *     transaction token in the user's session</li>
     * </ul>
     *
     * @param request The servlet request we are processing
     * @param reset Should we reset the token after checking it?
     */
    public synchronized boolean isTokenValid(
        HttpServletRequest request,
        boolean reset) {

        // Retrieve the current session for this request
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        // Retrieve the transaction token from this session, and
        // reset it if requested
        	String saved = (String) session.getAttribute(TRANSACTION_TOKEN_KEY);      
        	if (saved == null) {
            return false;
        }

        if (reset) {
            this.resetToken(request);
        }

        // Retrieve the transaction token included in this request
        String token = request.getParameter(TOKEN_KEY);
        if (token == null) {
            return false;
        }

        return saved.equals(token);
    }

    /**
     * Reset the saved transaction token in the user's session.  This
     * indicates that transactional token checking will not be needed
     * on the next request that is submitted.
     *
     * @param request The servlet request we are processing
     */
    public synchronized void resetToken(HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        session.removeAttribute(TRANSACTION_TOKEN_KEY);
    }

    /**
     * Save a new transaction token in the user's current session, creating
     * a new session if necessary.
     *
     * @param request The servlet request we are processing
     */
    public synchronized void saveToken(HttpServletRequest request) {

        HttpSession session = request.getSession();
        String token = generateToken(request);
        if (token != null) {
            session.setAttribute(TRANSACTION_TOKEN_KEY, token);
        }

    }

    /**
     * Generate a new transaction token, to be used for enforcing a single
     * request for a particular transaction.
     *
     * @param request The request we are processing
     */
    public String generateToken(HttpServletRequest request) {

        HttpSession session = request.getSession();
        try {
            byte id[] = session.getId().getBytes();
            byte now[] = new Long(System.currentTimeMillis()).toString().getBytes();
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(id);
            md.update(now);
            return this.toHex(md.digest());

        } catch (IllegalStateException e) {
            return null;
        } catch (NoSuchAlgorithmException e) {
            return null;
        }

    }

    /**
     * Convert a byte array to a String of hexadecimal digits and return it.
     *<p>
     *<strong>WARNING</strong>: This method is not part of TokenProcessor's
     *public API.  It's provided for backward compatibility only.
     *</p>
     * @param buffer The byte array to be converted
     */
    public String toHex(byte buffer[]) {
        StringBuffer sb = new StringBuffer();
        String s = null;
        for (int i = 0; i < buffer.length; i++) {
            s = Integer.toHexString((int) buffer[i] & 0xff);
            if (s.length() < 2) {
                sb.append('0');
            }
            sb.append(s);
        }
        return sb.toString();
    }

}
