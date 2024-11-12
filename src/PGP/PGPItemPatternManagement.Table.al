table 85080 PGPItemPatternManagement
{
    Caption = 'Item Management Template';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;

            trigger OnValidate()
            begin
                "Variant Code" := '';
                if not Item.Get("Item No.") then
                    Item.Init;
                Description := Item.Description;
                "Unit Of Measure" := Item."Base Unit of Measure";
                "Qty. per Unit of Measure" := 1;
                Validate(Quantity, 0);
            end;
        }
        field(2; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                VarianteProd: Record "Item Variant";
            begin
                if "Variant Code" = '' then
                    exit;
                ItemVariant.Get("Item No.", "Variant Code");
                Description := ItemVariant.Description;
            end;
        }
        field(3; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure");
                "Quantity (Base)" := Round(Quantity * "Qty. per Unit of Measure", 0.000001);
            end;
        }
        field(4; "Unit Of Measure"; Code[10])
        {
            Caption = 'Unit Of Measure';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                TestField("Item No.");
                Item.Get("Item No.");
                "Qty. per Unit of Measure" :=
                  UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit Of Measure");
                if CurrFieldNo = FieldNo("Unit Of Measure") then
                    Validate(Quantity);
            end;
        }
        field(5; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(6; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate(Quantity, "Quantity (Base)");
            end;
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(20; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            begin
                Clear("Bin Code");
            end;
        }
        field(21; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));

            trigger OnValidate()
            var
                ProdOrderComp: Record "Prod. Order Component";
                WhseIntegrationMgt: Codeunit "Whse. Integration Management";
            begin
            end;
        }
        field(30; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';

            trigger OnLookup()
            begin
                SelectLotNo;
            end;
        }
        field(31; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';

            trigger OnLookup()
            begin
                SelectSerialNo;
            end;
        }
        field(40; "Item Ledger Entry No."; Integer)
        {
        }
        field(41; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';

            trigger OnLookup()
            begin
                SelectExpirationDate;
            end;
        }
        field(42; "Warranty Date"; Date)
        {
            Caption = 'Warranty Date';

            trigger OnLookup()
            begin
                SelectWarrantyDate;
            end;
        }
    }

    keys
    {
        key(Key1; "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record Item;
        ItemVariant: Record "Item Variant";
        UOMMgt: Codeunit "Unit of Measure Management";

    local procedure SelectLotNo()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        TestField("Item No.");
        TestItemTracking(FieldNo("Lot No."));
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentKey("Item No.", "Variant Code", Open);
        ItemLedgerEntry.SetRange("Item No.", "Item No.");
        ItemLedgerEntry.SetRange("Variant Code", "Variant Code");
        ItemLedgerEntry.SetRange("Location Code", "Location Code");
        ItemLedgerEntry.SetRange(Open, true);
        ItemLedgerEntry.SetRange(Positive, Quantity > 0);
        if PAGE.RunModal(PAGE::"Item Ledger Entries", ItemLedgerEntry) = ACTION::LookupOK then begin
            "Lot No." := ItemLedgerEntry."Lot No.";
            "Serial No." := ItemLedgerEntry."Serial No.";
            "Expiration Date" := ItemLedgerEntry."Expiration Date";
            "Warranty Date" := ItemLedgerEntry."Warranty Date";
        end;
    end;

    local procedure SelectSerialNo()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        TestField("Item No.");
        TestItemTracking(FieldNo("Serial No."));
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentKey("Item No.", "Variant Code", Open);
        ItemLedgerEntry.SetRange("Item No.", "Item No.");
        ItemLedgerEntry.SetRange("Variant Code", "Variant Code");
        ItemLedgerEntry.SetRange("Location Code", "Location Code");
        ItemLedgerEntry.SetRange(Open, true);
        ItemLedgerEntry.SetRange(Positive, Quantity > 0);
        if PAGE.RunModal(PAGE::"Item Ledger Entries", ItemLedgerEntry) = ACTION::LookupOK then begin
            "Lot No." := ItemLedgerEntry."Lot No.";
            "Serial No." := ItemLedgerEntry."Serial No.";
            "Expiration Date" := ItemLedgerEntry."Expiration Date";
            "Warranty Date" := ItemLedgerEntry."Warranty Date";
        end;
    end;

    local procedure SelectExpirationDate()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        TestField("Item No.");
        TestItemTracking(FieldNo("Expiration Date"));
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentKey("Item No.", "Variant Code", Open);
        ItemLedgerEntry.SetRange("Item No.", "Item No.");
        ItemLedgerEntry.SetRange("Variant Code", "Variant Code");
        ItemLedgerEntry.SetRange("Location Code", "Location Code");
        ItemLedgerEntry.SetRange(Open, true);
        ItemLedgerEntry.SetRange(Positive, Quantity > 0);
        if PAGE.RunModal(PAGE::"Item Ledger Entries", ItemLedgerEntry) = ACTION::LookupOK then begin
            "Lot No." := ItemLedgerEntry."Lot No.";
            "Serial No." := ItemLedgerEntry."Serial No.";
            "Expiration Date" := ItemLedgerEntry."Expiration Date";
            "Warranty Date" := ItemLedgerEntry."Warranty Date";
        end;
    end;

    local procedure SelectWarrantyDate()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        TestField("Item No.");
        TestItemTracking(FieldNo("Warranty Date"));
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentKey("Item No.", "Variant Code", Open);
        ItemLedgerEntry.SetRange("Item No.", "Item No.");
        ItemLedgerEntry.SetRange("Variant Code", "Variant Code");
        ItemLedgerEntry.SetRange("Location Code", "Location Code");
        ItemLedgerEntry.SetRange(Open, true);
        ItemLedgerEntry.SetRange(Positive, Quantity > 0);
        if PAGE.RunModal(PAGE::"Item Ledger Entries", ItemLedgerEntry) = ACTION::LookupOK then begin
            "Lot No." := ItemLedgerEntry."Lot No.";
            "Serial No." := ItemLedgerEntry."Serial No.";
            "Expiration Date" := ItemLedgerEntry."Expiration Date";
            "Warranty Date" := ItemLedgerEntry."Warranty Date";
        end;
    end;

    local procedure TestItemTracking(FromFieldNo: Integer)
    var
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        TestField("Item No.");
        if Item.Get("Item No.") and ("Lot No." <> '') then begin
            Item.TestField("Item Tracking Code");
            ItemTrackingCode.Get(Item."Item Tracking Code");
            case FromFieldNo of
                FieldNo("Lot No."):
                    ItemTrackingCode.TestField("Lot Specific Tracking");
                FieldNo("Serial No."):
                    ItemTrackingCode.TestField("SN Specific Tracking");
                FieldNo("Expiration Date"):
                    ItemTrackingCode.TestField("Man. Expir. Date Entry Reqd.");
                FieldNo("Warranty Date"):
                    ItemTrackingCode.TestField("Man. Warranty Date Entry Reqd.");
            end;
        end;
    end;
}

