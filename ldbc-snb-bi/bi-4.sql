WITH top100_popular_forums AS (
  SELECT fp_forumid AS forumid
    FROM forum_person fp
       , person p
       , place ci 
       , place co 
   WHERE 1=1
     AND fp.fp_personid = p.p_personid
     AND p.p_placeid = ci.pl_placeid
     AND ci.pl_containerplaceid = co.pl_placeid
     AND co.pl_name = 'Belarus'
   GROUP BY fp_forumid
   ORDER BY count(*) DESC, fp_forumid
   LIMIT 100
)
SELECT au.p_personid AS "person.id"
     , au.p_firstname AS "person.firstName"
     , au.p_lastname AS "person.lastName"
     , au.p_creationdate
     , count(DISTINCT p.m_messageid) AS postCount
  FROM top100_popular_forums t
       INNER JOIN forum_person fp ON (t.forumid = fp.fp_forumid)
       INNER JOIN person au ON (fp.fp_personid = au.p_personid)
       LEFT JOIN message p ON (1=1
                        AND au.p_personid = p.m_creatorid
                        AND p.m_ps_forumid IN (SELECT forumid from top100_popular_forums)
                        AND p.m_c_replyof IS NULL
                           )
 GROUP BY au.p_personid, au.p_firstname, au.p_lastname, au.p_creationdate
 ORDER BY postCount DESC, au.p_personid
 LIMIT 100
;
