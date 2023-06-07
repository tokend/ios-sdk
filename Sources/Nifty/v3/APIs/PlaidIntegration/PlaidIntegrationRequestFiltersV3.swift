//
//  PlaidIntegrationRequestFiltersV3.swift
//  da
//
//  Created by Jonikorjk on 07.06.2023.
//

import Foundation

public enum PlaidIntegrationRequestFileterOptionV3: FilterOption {
    case accountsId(String)
}

public class PlaidIntegrationRequestFiletersV3: RequestFilters<PlaidIntegrationRequestFileterOptionV3> {}
