table 85090 CNFTableNameSetup
{
    // CNF Cadenas a sustituir
    // =================================
    // CNFTableName
    // CNFTableCaptionENU
    // CNFTableCaptionESP

    Caption = 'CNFTableCaptionENU Setup';

    fields
    {
        field(1; "Primary Key"; Integer)
        {
            Caption = 'Primary Key';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

