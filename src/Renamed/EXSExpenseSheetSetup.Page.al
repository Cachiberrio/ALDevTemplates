page 85006 EXSExpenseSheetSetup
{
    Caption = 'Expense Sheet Sertup';
    PageType = Card;
    SourceTable = EXSExpenseSheetSetup;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Expense Sheet No. Series"; Rec."Expense Sheet No. Series")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

