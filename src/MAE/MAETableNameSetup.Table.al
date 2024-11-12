table 85072 MAETableNameSetup
{
    Caption = 'MAETableCaptionENU Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "MAETableName No. Series"; Code[10])
        {
            Caption = 'MAETableName No. Series';
            TableRelation = "No. Series";
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

