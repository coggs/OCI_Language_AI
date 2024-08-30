-- Run this on Admin to provide corrent DB Grants to your DB User
-- Configure your user.
define myuser = 'someusername';
 
-- Grant the resource principal privilege to the user.
exec dbms_cloud_admin.enable_resource_principal('&myuser');
 
-- Additional grants.
grant create mining model to &myuser;
grant execute on c##cloud$service.dbms_cloud to &myuser;
grant execute on sys.dbms_vector to &myuser;
grant execute on ctxsys.dbms_vector_chain to &myuser;
grant read,write on directory data_pump_dir to &myuser;
 
-- This is required when working with third-part APIs.
begin
  dbms_network_acl_admin.append_host_ace(
    host => '*'
    , ace => xs$ace_type(
        privilege_list => xs$name_list('connect')
        , principal_name => '&myuser'
        , principal_type => xs_acl.ptype_db
    )
  );
end;
