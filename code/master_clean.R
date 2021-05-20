library(tidyverse)

setwd("/Users/xiafm/Documents/GitHub/NJ-opioidenv/data_final")
master <- read.csv("master.csv")
colnames(master)

# selected variables from the master file
selected_var <- master %>%
  select(-c(X, pct_res_tot, pct_com_tot, pct_ind_tot, 
            multiunits_10_to_19, multiunits_20_to_49, multiunits_50plus, multiunits_five_to_nine, multiunits_three_or_four, multiunits_two,
            occupied_owner, occupied_renter, occupied_units,
            pop_own_90_99, pop_own_bfr89, pop_own_occ, pop_ren_90_99, pop_ren_bfr89, pop_ren_occ, 
            pop_own_20yrs_plus, pop_ren_20yrs_plus, pop_20yrs_plus, 
            vac_3_res, vac_3_bus, vac_3_oth, vac_3_6_r, vac_3_6_b, vac_3_6_o, 
            vac_6_12r, vac_12_24r, vac_12_24b, vac_12_24o, vac_24_36r, vac_24_36b, vac_24_36o,
            vac_36_res, vac_36_bus, vac_36_oth, vac_6_12b, vac_6_12o, 
            ns_6_12_b, ns_6_12_o,
            pqv_is_res, pqv_is_bus, pqv_is_oth, pqv_ns_res, pqv_ns_bus, pqv_ns_oth,
            nostat_res, nostat_bus, nostat_oth, avg_ns_res, avg_ns_bus, avg_ns_oth,
            ns_3_res, ns_3_bus, ns_3_oth, ns_3_6_res, ns_3_6_bus, ns_3_6_oth, 
            ns_6_12_r, ns_12_24_r, ns_12_24_b, ns_12_24_o, ns_24_36_r, ns_24_36_b, ns_24_36_o,
            ns_36_res, ns_36_bus, ns_36_oth, pqns_is_r, pqns_is_b, pqns_is_o
            )
         )

# merge with ndvi
distance_matrix_ndvi <- read.csv("distance_matrix_ndvi.csv")

merge_ndvi <- selected_var %>%
  full_join(distance_matrix_ndvi, by = "SSN") %>%
  select(-Place.Name) %>%
  select(SSN, municipality, everything())

# merge with SVI
svi_mun <- read.csv("svi_mun.csv")

merge_svi <- merge_ndvi %>%
  full_join(svi_mun, by = "SSN") %>%
  select(-Place.Name) %>%
  select(SSN, municipality, everything())

# merge with adult_ed_distance
adult_ed_distance <- read.csv("adult_ed_distance.csv")

# merge with cultural_distance
cultural_distance <- read.csv("cultural_distance.csv")
cultural_distance <- cultural_distance %>%
  rename(cultural_dist = average_distance)

# merge with naloxone_distance
naloxone_distance <- read.csv("naloxone_distance.csv")
naloxone_distance <- naloxone_distance %>%
  rename(naloxone_dist = average_distance)

# merge with syringe_distance
syringe_distance <- read.csv("syringe_distance.csv")
syringe_distance <- syringe_distance %>%
  rename(syringe_distance = average_distance)

master_clean <- merge_svi %>%
  full_join(adult_ed_distance, by = "SSN") %>%
  full_join(cultural_distance, by = "SSN") %>%
  full_join(naloxone_distance, by = "SSN") %>%
  full_join(syringe_distance, by = "SSN") %>%
  select(SSN, municipality, everything())

colnames(master_clean)

#write_csv(master_clean, file = "master_clean.csv")

master_clean <- read.csv("master_clean.csv")

