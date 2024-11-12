page 85050 MCPTableNameList
{
    Caption = 'MCPTableCaptionENU List';
    CardPageID = MCPTableNameCard;
    Editable = false;
    PageType = List;
    SourceTable = MCPTableName;

    layout
    {
        area(content)
        {
            repeater(Control1170170000)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(City; Rec.City)
                {
                }
                field("Phone No."; Rec."Phone No.")
                {
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field(County; Rec.County)
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Visible = false;
                }
                field("Entry Date"; Rec."Entry Date")
                {
                    Visible = false;
                }
                field("Leaving Date"; Rec."Leaving Date")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Maestro")
            {
                Caption = '&Maestro';
                action(Card)
                {
                    Caption = 'Card';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page MCPTableNameCard;
                    RunPageLink = "No." = FIELD("No.");
                }
                action(Customer)
                {
                    Caption = 'Customer';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Customer List";
                    RunPageLink = "No." = FIELD("Customer No.");
                    RunPageMode = View;
                }
                action(Vendor)
                {
                    Caption = 'Vendor';
                    Image = VendorLedger;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Vendor List";
                    RunPageLink = "No." = FIELD("Vendor No.");
                    RunPageMode = View;
                }
            }
            group("Acci&ones")
            {
                Caption = 'Acci&ones';
                action("Create Customer")
                {
                    Caption = 'Create Customer';
                    Image = CreateInteraction;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.CreateCustomer();
                        CurrPage.Update;
                    end;
                }
                action("Create Vendor")
                {
                    Caption = 'Create Vendor';
                    Image = CreateInteraction;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.CreateVendor;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }
}

