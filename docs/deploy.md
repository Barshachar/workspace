# פריסה

1. הגדרו את הסודות `SUPABASE_ACCESS_TOKEN` ו-`SUPABASE_PROJECT_REF` בגיטהאב.
2. הקונפיגורציה משתמשת בסקריפט CI (`deploy.yml`) המפעיל בדיקות ובונה את האפליקציה.
3. לאחר מעבר הבדיקות, המיגרציות והפונקציות נפרסות אוטומטית ל-Supabase.
4. בממשק GitHub, עברו ל-Settings → Secrets → Actions והוסיפו את הערכים.
   צפו בצילום המסך `docs/img/secrets.png` להמחשה.
5. ל-Push באייפון נדרש להעלות תעודת APNs בממשק Supabase.
![APNs](img/apns.png)
