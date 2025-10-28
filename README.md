# A Shachar B2B App

זהו מאגר הקוד של אפליקציית ההזמנות B2B. לפני הרצה יש ליצור קובץ `.env` על בסיס `.env.example` ולמלא את המפתחות של Supabase, Stripe ועוד. בנוסף נדרש להתקין Flutter 3.22 ומעלה, להריץ `supabase init` ולהפעיל את שירותי Supabase והפונקציות.

### הגדרות סביבת פיתוח
1. העתקו את הקובץ `.env.example` ל-`.env` ומלאו את הערכים `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `STRIPE_PK`, `STRIPE_SK`, `FCM_SERVICE_ACCOUNT`.
2. הגדירו בממשק GitHub את הסודות `SUPABASE_ACCESS_TOKEN` ו-`SUPABASE_PROJECT_REF` לביצוע הפריסה האוטומטית.
3. להרצת Supabase מקומית השתמשו ב-`supabase start`.
4. כרטיסי הבדיקה של Stripe נמצאים בתיעוד הרשמי (למשל 4242 4242 4242 4242).
5. הגדרו ב-Supabase את ה-API Key לגישה מהפונקציות והעתיקו אותו ל`.env`.
6. לצורך חיבור Webhook של Stripe, הכניסו את כתובת `/functions/v1/create-payment-intent` בממשק Stripe.
שמרו את ה-signing secret תחת STRIPE_WEBHOOK_SECRET והגדירו ב-GitHub Secrets.
7. לבדיקת פונקציות Edge מקומית הריצו `supabase functions serve`.
8. לצורך Push ב-iOS העלו תעודת APNs והגדירו את הנתיב בקובץ `.env`.

## פקודות נפוצות
```bash
flutter pub get
flutter run -d chrome
flutter test --coverage
```

למידע נוסף על המודולים (BNPL, Green Invoice, AI) ראו בתיקייה `docs/`.
### בדיקות מקומיות של Edge Functions
ניתן להריץ פונקציה מקומית:
```bash
supabase functions serve predict-reorder
```
ולבדוק עם curl:
```bash
curl -X POST http://localhost:54321/functions/v1/predict-reorder
```

### מפתח API לסופבייס
במסך Settings → API ב-Supabase מצאו את ה-Service Role וצרפו אותו כ-`SUPABASE_SERVICE_ROLE_KEY` ב-`.env` ובלשונית הסודות של GitHub.
\nלמידע על מצב לא מקוון ראו docs/offline.md

## Branch Protection
- יש לפתוח Pull Request עבור כל שינוי לענף `main`.
- נדרש אישור סקירה אחד לפחות לפני מיזוג.
- יש לוודא שכל בדיקות ה-CI (לדוגמה, "Flutter Tests") עוברות בהצלחה לפני מיזוג.
