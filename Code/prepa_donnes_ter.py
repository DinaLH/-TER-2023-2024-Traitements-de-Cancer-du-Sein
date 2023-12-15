

# Application de l'ACP pour la réduction de dimensionnalité
pca = PCA(n_components=2)  # Utilisation de 2 composantes pour la visualisation
X_pca = pca.fit_transform(df_transformed)

# Application du clustering K-Means
kmeans = KMeans(n_clusters=3)  # Le nombre de clusters peut être ajusté
clusters = kmeans.fit_predict(X_pca)

# Création d'un DataFrame pour la visualisation
df_vis = pd.DataFrame(X_pca, columns=['PC1', 'PC2'])
df_vis['Cluster'] = clusters

# Visualisation des clusters
plt.figure(figsize=(10, 8))
sns.scatterplot(data=df_vis, x='PC1', y='PC2', hue='Cluster', palette='viridis')

# Ajout des titres et étiquettes
plt.title('Visualisation des Clusters avec ACP')
plt.xlabel('Composante Principale 1')
plt.ylabel('Composante Principale 2')

# Affichage du graphique
plt.show()

top_n = 10  # Nombre de top séquences à afficher
top_sequences = df_sequence_counts.orderBy(col("count").desc()).limit(top_n).toPandas()

sns.barplot(x='sequence_name', y='count', data=top_sequences)
plt.title(f'Top {top_n} des Séquences les Plus Fréquentes')
plt.xlabel('Nom de la Séquence')
plt.ylabel('Nombre d’Occurrences')
plt.xticks(rotation=45)
plt.show()

# Sélectionner les colonnes numériques pour l'ACP
numeric_columns = [field.name for field in df_transformed.schema.fields if isinstance(field.dataType, (FloatType, DoubleType))]

print("Colonnes numériques sélectionnées:", numeric_columns)

import pandas as pd
import numpy as np


# Exporter df_transformed en DataFrame Pandas
pandas_df = df_transformed.toPandas()

# Filtrer uniquement les colonnes numériques
numeric_cols = pandas_df.select_dtypes(include=[np.number])

# Afficher les premières lignes pour vérifier
print(numeric_cols.head())

from sklearn.decomposition import PCA
import pandas as pd

# Conversion du DataFrame PySpark en DataFrame Pandas
pandas_df = df_transformed_all_filled.toPandas()

# Sélectionner uniquement les colonnes numériques pour l'ACP
numeric_columns = [col for col in pandas_df.columns if col != 'sequence_name']
data_for_pca = pandas_df[numeric_columns]

# Réaliser l'ACP
pca = PCA(n_components=2)
principal_components = pca.fit_transform(data_for_pca)

# Créer un DataFrame pour les composantes principales
pca_df = pd.DataFrame(data=principal_components, columns=['PC1', 'PC2'])

# Afficher les résultats
print(pca_df.head())

import matplotlib.pyplot as plt
import seaborn as sns

# Calculer les coefficients de chargement
loadings = pca.components_.T * np.sqrt(pca.explained_variance_)

# Créer un DataFrame pour les coefficients de chargement
loadings_df = pd.DataFrame(loadings, columns=['PC1', 'PC2'], index=numeric_columns)

# Créer le graphique du cercle des corrélations
plt.figure(figsize=(10, 8))
sns.scatterplot(data=loadings_df, x='PC1', y='PC2')

# Ajouter les annotations pour chaque point
for i in range(loadings_df.shape[0]):
    plt.text(loadings_df.PC1[i], loadings_df.PC2[i], loadings_df.index[i], fontsize=9)

# Dessiner les axes et un cercle unitaire
plt.axhline(0, color='grey', linestyle='--')
plt.axvline(0, color='grey', linestyle='--')
circle = plt.Circle((0, 0), 1, color='blue', fill=False)
plt.gca().add_artist(circle)

# Titre et étiquettes
plt.title('Cercle des corrélations')
plt.xlabel('PC1')
plt.ylabel('PC2')

# Afficher le graphique
plt.show()

from pyspark.sql.functions import col
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler


# Sélection des colonnes numériques
numeric_columns = [col for col in pandas_df.columns if col != 'sequence_name']
data_for_pca = pandas_df[numeric_columns]

# Gestion des valeurs manquantes
data_for_pca = data_for_pca.fillna(data_for_pca.mean())

# Réaliser l'ACP
pca = PCA(n_components=2)
principal_components = pca.fit_transform(data_for_pca)

# Création d'un DataFrame pour les composantes principales
pca_df = pd.DataFrame(data=principal_components, columns=['PC1', 'PC2'])

# Standardisation des features pour le clustering
scaler = StandardScaler()
X_scaled = scaler.fit_transform(pca_df)

# Application du clustering K-Means
kmeans = KMeans(n_clusters=3)  # Ajustez le nombre de clusters si nécessaire
clusters = kmeans.fit_predict(X_scaled)

# Ajout des clusters au DataFrame
pca_df['Cluster'] = clusters

# Visualisation des clusters
plt.figure(figsize=(10, 8))
sns.scatterplot(data=pca_df, x='PC1', y='PC2', hue='Cluster', palette='viridis')
plt.title('Visualisation des Clusters avec ACP')
plt.xlabel('Composante Principale 1')
plt.ylabel('Composante Principale 2')
plt.show()

# Valeurs propres
eigenvalues = pca.explained_variance_

# Pourcentage de variance expliquée par chaque composante
explained_variance_ratio = pca.explained_variance_ratio_ * 100

# Afficher les résultats
print("Valeurs propres : ", eigenvalues)
print("Pourcentage de variance expliquée par chaque composante : ", explained_variance_ratio)

# Contribution absolue de chaque variable à chaque PC
absolute_contributions = np.square(loadings) * eigenvalues

# Contribution relative (en pourcentage)
relative_contributions = absolute_contributions / eigenvalues.sum() * 100

# Créer un DataFrame pour les contributions
contributions_df = pd.DataFrame(relative_contributions, index=numeric_columns, columns=['Contribution to PC1', 'Contribution to PC2'])

# Afficher les contributions
print(contributions_df)

import plotly.express as px
import pandas as pd

# Données des composantes principales
data = {
    "PC1": [-1.276943, -3.558129, -3.527010, -3.674288, -3.400422],
    "PC2": [-2.125863, -0.278803, -2.239697, -4.686829, -2.035044]
}
df_pca = pd.DataFrame(data)

# Données de contributions
data_contributions = {
    "Variable": ["MA0002.1::RUNX1", "MA0002.2::Runx1", "MA0003.1::TFAP2A", "MA0003.2::TFAP2A", "MA0003.3::TFAP2A"],
    "Contribution to PC1": [0.927942, 0.095499, 0.659001, 0.199108, 0.383355],
    "Contribution to PC2": [0.000168, 0.000125, 0.000168, 0.000165, 0.000091]
}
df_contributions = pd.DataFrame(data_contributions)

# Création du graphique de cercle de corrélation
fig = px.scatter(df_contributions, x='Contribution to PC1', y='Contribution to PC2', hover_data=['Variable'])

# Améliorer la mise en page
fig.update_layout(
    title="Cercle de corrélation interactif",
    xaxis_title="Contribution to PC1",
    yaxis_title="Contribution to PC2",
    hovermode="closest"
)

# Afficher les étiquettes uniquement lors du survol
fig.update_traces(
    textposition='top center',
    marker_size=10,
    hoverinfo='text+name'
)

fig.show()

import plotly.express as px
import pandas as pd
from sklearn.decomposition import PCA

# Supposons que df_transformed est votre DataFrame Spark transformé
# Conversion du DataFrame PySpark en DataFrame Pandas
pandas_df = df_transformed_all_filled.toPandas()

# Sélection des colonnes numériques
numeric_columns = pandas_df.select_dtypes(include=['float64', 'int64']).columns

# Application de l'ACP
pca = PCA(n_components=2)
pca_result = pca.fit_transform(pandas_df[numeric_columns])

# Calcul des contributions
loadings = pca.components_.T * np.sqrt(pca.explained_variance_)

# Création du DataFrame de contributions
df_contributions = pd.DataFrame(loadings, columns=['PC1', 'PC2'], index=numeric_columns)

# Création du graphique Plotly
fig = px.scatter(
    df_contributions,
    x='PC1',
    y='PC2',
    hover_name=df_contributions.index,
    title='Cercle de corrélation interactif pour l\'ACP'
)

# Amélioration de la mise en page
fig.update_layout(
    xaxis_title="Contribution à PC1",
    yaxis_title="Contribution à PC2",
    hovermode='closest'
)

# Affichage du graphique
fig.show()

# Conversion du DataFrame PySpark en DataFrame Pandas
pandas_df = df_transformed_all_filled.toPandas()

# Calcul des statistiques descriptives
descriptive_stats = pandas_df.describe()

# Nombre de valeurs uniques pour chaque colonne
unique_values = pandas_df.nunique()

# Affichage des résultats
print(descriptive_stats)
print("\nNombre de valeurs uniques par colonne:\n", unique_values)

import plotly.graph_objects as go

# Calcul de la moyenne et de l'écart-type
mean_values = pandas_df.mean()
std_dev_values = pandas_df.std()

# Création du diagramme
fig = go.Figure()
fig.add_trace(go.Bar(x=mean_values.index, y=mean_values, error_y=dict(type='data', array=std_dev_values)))
fig.update_layout(title='Moyenne et écart-type de chaque variable', xaxis_title='Variables', yaxis_title='Valeur')
fig.show()

import plotly.express as px

# Sélection aléatoire de quelques colonnes
sampled_columns = pandas_df.sample(n=10, axis=1)  # Modifiez le nombre selon la visibilité

# Création des boxplots interactifs
fig = px.box(sampled_columns, points="all")
fig.update_layout(title='Boxplots groupés pour des variables sélectionnées')
fig.show()

from pandas.plotting import scatter_matrix
import pandas as pd
# Sélectionner un sous-ensemble de colonnes
subset_data = pandas_df[subset_columns]

# Créer un scatter plot matriciel
scatter_matrix(subset_data, alpha=0.2, figsize=(10, 10), diagonal='kde')
plt.show()