//
//  SupabaseCowriter.swift
//  Cowriter
//
//  Created by Aditya Cahyo on 01/05/23.
//

import Foundation
import Supabase

final class SupabaseCowriter {
    static let client: SupabaseClient = {
        let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String ?? ""
        let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as? String ?? ""
        let supabaseURL = URL(string: "https://\(urlString)")!

        return SupabaseClient(supabaseURL: supabaseURL, supabaseKey: key)
    }()
}
