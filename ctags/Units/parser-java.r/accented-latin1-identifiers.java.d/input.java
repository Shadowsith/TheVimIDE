    void ueberweisen ( Konto empf�nger, int betrag ) {
	abheben(betrag);
	empf�nger.einzahlen(betrag);
    }
