# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create profiles
Profile.create(name: 'Administrador')
Profile.create(name: 'Instructor')
Profile.create(name: 'Usuario')

# Create decisions
Decision.create(description: 'No Falta', initials: 'NF')
Decision.create(description: 'Tiro Libre Indirecto', initials: 'TLI')
Decision.create(description: 'Tiro Libre Directo', initials: 'TLD')
Decision.create(description: 'Tiro Penal', initials: 'TP')

# Create sanctions
Sanction.create(description: 'No Tarjeta', initials: 'NT')
Sanction.create(description: 'Tarjeta Amarilla', initials: 'TA')
Sanction.create(description: 'Tarjeta Roja', initials: 'TR')
