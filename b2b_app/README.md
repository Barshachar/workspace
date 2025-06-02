# b2b_app

## הוראות התחלה מהירה

1. התקינו את Flutter 3.22 ומעלה.
2. הריצו `supabase init` בתיקיית הפרויקט כדי להגדיר את Supabase.
3. העתקו את `.env.example` ל-`.env` ומלאו את המפתחות (Supabase, Stripe ועוד).
3. להרצת האפליקציה:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```
4. להרצת בדיקות:
  ```bash
  flutter test
  ```

## מודולים מתקדמים
- BNPL: בדיקת אשראי לפני תשלום.
- Green Invoice: הנפקת חשבונית ירוקה לאחר תשלום.
- AI Recommendations: מוצרים מומלצים בדף הבית.
