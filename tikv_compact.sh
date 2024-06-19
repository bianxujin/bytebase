#!/bin/bash
sql="""select r.region_id 
     from 
    INFORMATION_SCHEMA.tikv_region_status as r
    join 
    INFORMATION_SCHEMA.TIKV_REGION_PEERS as p
    on r.region_id = p.region_id
    join
    INFORMATION_SCHEMA.TIKV_STORE_STATUS as st
    on p.store_id=st.store_id
    where r.table_name='sbtest1' and r.db_name='sbtest'  and  r.is_index=1
    and st.address='10.11.110.58:20160' order by r.start_key asc"""
for region_id in `/data1/mysql/mysql3306/app/mysql/bin/mysql -h 10.11.110.55 -P 4000 -p2EfR-x35@vT_P*6F09 -e "$sql" -N` ;
do
   /home/tidb/.tiup/components/ctl/v7.5.1/tikv-ctl --host 10.11.110.58:20160  compact -d kv  --bottommost -c default -r $region_id
   sleep 0.5
   /home/tidb/.tiup/components/ctl/v7.5.1/tikv-ctl --host 10.11.110.58:20160  compact -d kv  --bottommost force -c write -r $region_id 
   sleep 0.5
   mvcc_delete=`/home/tidb/.tiup/components/ctl/v7.5.1/tikv-ctl --host 10.11.110.58:20160 region-properties -r $region_id  | grep delete | sed -n '1p'`
   echo "region_id":$region_id "mvcc_delete":$mvcc_delete
done 
