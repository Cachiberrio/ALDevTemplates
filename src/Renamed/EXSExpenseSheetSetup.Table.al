table 85005 EXSExpenseSheetSetup
{
    Caption = '<DocumentName> Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Expense Sheet No. Series"; Code[10])
        {
            Caption = 'Expense Sheet No. Series';
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

