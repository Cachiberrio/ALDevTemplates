page 85090 CNFTableNameSetup
{
    Caption = 'CNFTableCaptionENU Setup';
    PageType = Card;
    SourceTable = CNFTableNameSetup;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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

