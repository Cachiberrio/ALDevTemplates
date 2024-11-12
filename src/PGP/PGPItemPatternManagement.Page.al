page 85080 PGPItemPatternManagement
{
    Caption = 'Item Management Template';
    PageType = List;
    SourceTable = PGPItemPatternManagement;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit Of Measure"; Rec."Unit Of Measure")
                {
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Visible = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Visible = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    Visible = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    Visible = false;
                }
                field("Warranty Date"; Rec."Warranty Date")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

